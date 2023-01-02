Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD8B65B74B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 Jan 2023 22:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjABVAb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 16:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjABVAa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 16:00:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232F7672;
        Mon,  2 Jan 2023 13:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A300CB80DE8;
        Mon,  2 Jan 2023 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0029FC433D2;
        Mon,  2 Jan 2023 21:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672693224;
        bh=l0htPdzn+vacqu1ADpy0Gu3qwhsPxvEkXdpUpWPagWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tylh0jj1ofjy5WDcqAbA1NRwUpJTXBmNkx09M6AjO8ADE1hT4y4sqegiDO5rEAXAh
         +XU0l0Q9bpXjOi3fg/Bs9MRPh29wLZuE/CEJVOfgdmcVT4meqzKLc98uM9DWyGS7C0
         Rv2XR9FdGcDQ+gLWliBClrSSyyjd5p6mX9NqjPAZi1U1k+WxK8G+4s22dCQ1l96QsI
         bKHmyH0maaBD8lLU7nsk+O3mFBdAkeujL9N8aY/wh4+jawVJGVczJGpJeeScdioOEP
         j4ePjUSZTK31opXzUnlxIEfJfAKeUMku0qchI0wDTlCYJ50SBTh6GXsPMBdaXheW+P
         4l/f+cfeoOhVw==
Date:   Mon, 2 Jan 2023 13:00:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 01/17] fscrypt: factor accessing inode->i_crypt_info
Message-ID: <Y7NF5jVPjecs58+Q@sol.localdomain>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <1d69320524e31f4f0ece20ba3c0d2b8244228f4f.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d69320524e31f4f0ece20ba3c0d2b8244228f4f.1672547582.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 01, 2023 at 12:06:05AM -0500, Sweet Tea Dorminy wrote:
> Currently, inode->i_crypt_info is accessed directly in many places;
> the initial setting occurs in one place, via cmpxchg_release, and
> the initial access is abstracted into fscrypt_get_info() which uses
> smp_load_acquire(), but there are many direct accesses. While many of
> them follow calls to fscrypt_get_info() on the same thread, verifying
> this is not always trivial.
> 
> For instance, fscrypt_crypt_block() does not obviously follow a call to
> fscrypt_get_info() on the same cpu; if some other mechanism does not
> ensure a memory barrier, it is conceivable that a filesystem could call
> fscrypt_crypt_block() on a cpu which had an old (NULL) i_crypt_info
> cached. Even if the cpu does READ_ONCE(i_crypt_info), I believe it's
> theoretically possible for it to see the old NULL value, since this
> could be happening on a cpu which did not do the smp_load_acquire().  (I
> may be misunderstanding, but memory-barriers.txt says that only the cpus
> involved in an acquire/release chain are guaranteed to see the correct
> order of operations, which seems to imply that a cpu which does not do
> an acquire may be able to see a memory value from before the release.)
> 
> For safety, then, and so each site doesn't need to be individually
> evaluated, this change factors all accesses of i_crypt_info to go
> through fscrypt_get_info(), ensuring every access uses acquire and is
> thus paired against an appropriate release.
> 
> (The same treatment is not necessary for setting i_crypt_info; the
> only unprotected setting is during inode cleanup, which is inevitably
> followed by freeing the inode; there are no uses past the unprotected
> setting possible.)
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

This patch is not necessary.  The rules for accessing ->i_crypt_info are
actually pretty simple: when it's unknown whether ->i_crypt_info has been set,
then it's necessary to use fscrypt_get_info() and check whether the resulting
pointer is NULL or not (or use fscrypt_has_encryption_key() which does both).
That's because another thread could set it concurrently.

In contrast, when it *is* known that ->i_crypt_info has been set, then that can
only be because fscrypt_has_encryption_key() was already executed on the same
thread, or because an operation that ensured the key is set up already happened.
For example, when doing I/O to a file, it's guaranteed that the file has been
opened.  In either case, direct access is fine.

- Eric
