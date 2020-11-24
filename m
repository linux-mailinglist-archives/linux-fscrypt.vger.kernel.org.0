Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37182C34BE
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 Nov 2020 00:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgKXXm0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 24 Nov 2020 18:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728982AbgKXXm0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 24 Nov 2020 18:42:26 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 608562100A;
        Tue, 24 Nov 2020 23:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606261345;
        bh=KAJWl0OBsGQqeiLErWrRxDNjM1Wbv9mxXjghZ+pYMxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0O9/cSvw5+fLkdPBEZCzDs8Laf2SY6KdYW3Z/6HYrcr0IJ6EeqKAisLs5uEM4ePpC
         crUJACZMk75/hZFUxitjd2eP47PoB0h7bABvIHcn2y18fIf8Eptke/KsuCFhDtWdoQ
         bTUOA7zCF+KCeWdQdkrLvT0i9pe/CQyz18SUBjUw=
Date:   Tue, 24 Nov 2020 15:42:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH] fscrypt: simplify master key locking
Message-ID: <X72aXth+cz3k7uvD@sol.localdomain>
References: <20201117032626.320275-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117032626.320275-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 16, 2020 at 07:26:26PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The stated reasons for separating fscrypt_master_key::mk_secret_sem from
> the standard semaphore contained in every 'struct key' no longer apply.
> 
> First, due to commit a992b20cd4ee ("fscrypt: add
> fscrypt_prepare_new_inode() and fscrypt_set_context()"),
> fscrypt_get_encryption_info() is no longer called from within a
> filesystem transaction.
> 
> Second, due to commit d3ec10aa9581 ("KEYS: Don't write out to userspace
> while holding key semaphore"), the semaphore for the "keyring" key type
> no longer ranks above page faults.
> 
> That leaves performance as the only possible reason to keep the separate
> mk_secret_sem.  Specifically, having mk_secret_sem reduces the
> contention between setup_file_encryption_key() and
> FS_IOC_{ADD,REMOVE}_ENCRYPTION_KEY.  However, these ioctls aren't
> executed often, so this doesn't seem to be worth the extra complexity.
> 
> Therefore, simplify the locking design by just using key->sem instead of
> mk_secret_sem.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fscrypt_private.h | 19 ++++++-------------
>  fs/crypto/hooks.c           |  8 +++++---
>  fs/crypto/keyring.c         |  8 +-------
>  fs/crypto/keysetup.c        | 20 +++++++++-----------
>  4 files changed, 21 insertions(+), 34 deletions(-)

Applied to fscrypt.git#master for 5.11.

- Eric
