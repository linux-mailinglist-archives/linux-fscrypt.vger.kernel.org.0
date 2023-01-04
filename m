Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA265CD6E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  4 Jan 2023 07:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbjADG7T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Jan 2023 01:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjADG6t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Jan 2023 01:58:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF877DFD0;
        Tue,  3 Jan 2023 22:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EB0CB81203;
        Wed,  4 Jan 2023 06:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE594C433D2;
        Wed,  4 Jan 2023 06:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672815526;
        bh=A5Zfogc/sz6TcmE5utXwOgFFIovnnjMqVtADVSdFIFk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g352m9v8ZhEtl9aFsgP0fB9nHIZGxJuNzYxlZeLr2QMuZ2xwZJNHIVoD/kK/wTJvG
         80A4d6n8rDCqYtZseIKP79DS/7GH6uAn1B8HjiP+sP7o+tkQtcCyx8gtpHROcTA6rj
         ev1K67aJPcJoqKHnfoKervDOk1KZpjDNlgehvmzGJKh6Y7vZAtmqfgFi55upmJDIKs
         XOcNz8B3Ble4MqcQxjghsLWiS5xfqajlSP4KE0UCAH8ezWGVt394GK5mDu+QInmZVX
         DSWGRLTWlh6QD6viJcScz3vfFjAkj0J/mYNopPHarc2ruFRZacaKmOOY8prQzO61YY
         ozGcEBBedHU1g==
Date:   Tue, 3 Jan 2023 22:58:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fsverity: remove debug messages and
 CONFIG_FS_VERITY_DEBUG
Message-ID: <Y7UjpFWy6R+J4BLV@sol.localdomain>
References: <20221215060420.60692-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221215060420.60692-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,SUSPICIOUS_RECIPS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 14, 2022 at 10:04:20PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> I've gotten very little use out of these debug messages, and I'm not
> aware of anyone else having used them.
> 
> Indeed, sprinkling pr_debug around is not really a best practice these
> days, especially for filesystem code.  Tracepoints are used instead.
> 
> Let's just remove these and start from a clean slate.
> 
> This change does not affect info, warning, and error messages.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/Kconfig            |  8 --------
>  fs/verity/enable.c           | 11 -----------
>  fs/verity/fsverity_private.h |  4 ----
>  fs/verity/init.c             |  1 -
>  fs/verity/open.c             | 21 ++-------------------
>  fs/verity/signature.c        |  2 --
>  fs/verity/verify.c           | 13 -------------
>  7 files changed, 2 insertions(+), 58 deletions(-)

Applied for 6.3.  (To
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git/log/?h=fsverity for now,
but there might be a new git repo soon, as is being discussed elsewhere.)

- Eric
