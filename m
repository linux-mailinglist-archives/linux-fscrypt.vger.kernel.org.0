Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2301E65B86F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Jan 2023 01:47:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbjACArm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 19:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjACArl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 19:47:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29F81155;
        Mon,  2 Jan 2023 16:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AB88B80E19;
        Tue,  3 Jan 2023 00:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9AD6C433D2;
        Tue,  3 Jan 2023 00:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672706858;
        bh=/kDYzjC+w/r5HZzODesCDdIyJj/ICbpee55OCbeK7ik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNR7wdCDNs4cMHjvGYS0g/zs1urMiF/0peqfVdNaOpEwAUcmwngOuHTP5kFMD4Pnc
         sCni1jPzTmnWHUaLirgub66AD0SCUGBj2VpjUHCq5a3ZYJ4o2vW8y/C/JwBduZDUmm
         PxewFjmTF/XJPb5Ytn+fEwLqRmkokFaRhIFxytTcaRRhNvaO0QRdiQEsyWPwzmdH7Q
         0WSa7XsPf89w9zIv+52kJKgINUPJIbhHkzVNeaV9datSJBU9xVcNBsR7q5QJIDKuCZ
         WsgW9Fx2ItLr0VhB6Lhb7l2BVik/B+HkbXGNtc5h167ymHGH7enpDprWPNhTPSN86O
         DsfVvmuZ+6aVg==
Date:   Mon, 2 Jan 2023 16:47:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Message-ID: <Y7N7KCCqYZPwjOGX@sol.localdomain>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
 <Y7NQ1CvPyJiGRe00@sol.localdomain>
 <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
 <Y7NgCKPnVybgBaq/@sol.localdomain>
 <66385ee9-3e11-f5a6-259d-ae504ab6dfaa@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66385ee9-3e11-f5a6-259d-ae504ab6dfaa@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 02, 2023 at 07:33:15PM -0500, Sweet Tea Dorminy wrote:
> 
> > 
> > Anyway, crypto_alloc_skcipher() takes a lock (crypto_alg_sem) under which memory
> > is allocated with GFP_KERNEL.  So neither preloading kernel modules nor
> > memalloc_nofs_save() helps for it; it's still not GFP_NOFS-safe.
> 
> I'm still confused. My understanding is that memalloc_nofs_save() means all
> allocations on that thread until memalloc_nofs_restore() is called
> effectively gets GFP_NOFS appended to the allocation flags. So since
> crypto_alloc_skcipher()'s allocation appears to be on the same thread as
> we'd be calling memalloc_nofs_save/restore(), it would presumably get
> allocated as though it had flags GFP_KERNEL | GFP_NOFS, even though the call
> is kzalloc(..., GFP_KERNEL, ...).
> 
> I don't understand how the lock would make a difference. Can you elaborate?
> 
> Sorry for my confusion...

Other tasks (using the crypto API for another purpose, perhaps totally unrelated
to fs/crypto/) can take crypto_alg_sem without taking the same precaution.  So,
when your task that is running in fs-reclaim context and has used
memalloc_nofs_save() tries to take the same lock, it might be that the lock is
already held by another thread that is waiting for fs-reclaim to complete in
order to satisfy a GFP_KERNEL allocation.

That's a deadlock.

Locks are only GFP_NOFS-safe when everyone agrees to use them that way.

- Eric
