Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F4419DE3
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Sep 2021 20:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbhI0SOG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 27 Sep 2021 14:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234406AbhI0SOF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 27 Sep 2021 14:14:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F389D60F11;
        Mon, 27 Sep 2021 18:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632766347;
        bh=rdgw3F1Kdg54mhTg7zw6yM4sruhDudWDVilQ00hU6B0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jiLJJvorosORlvLuM/PIpoArMAOWXSJsRVxKqu8GDcNFP66fXH3x6f1070Om5C8nI
         LwOysRGuGh/hmIVe0YCM2BucMNrk7ghD4hYHr6aVdB5Bs/jMlrM86qlzWBI2r7ZSO5
         0K9T3e/deKMaBoiPtw/3/1aUxFCMgSvngI0jCF6IirAufjJs5j+VbCDi6tPGI6L9OX
         VQyNNFtAYXKFRlUHj4IJdaD1ggS/e9E48aYzLOLVZ9tbeSCKRC1UuIJrEsJkaptNnI
         3Vxr46ZALv1ZVT0ehTuzbUbc60F3Mn4oA4Fcb92F2OpyzIddG6bNzXOAksRPOQ9Lvq
         Nhkxm5ItW4amA==
Date:   Mon, 27 Sep 2021 11:12:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [RFC PATCH v2 0/5] Support for hardware-wrapped inline
 encryption keys
Message-ID: <YVIJiX5CAI0cCh3H@gmail.com>
References: <20210916174928.65529-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916174928.65529-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 16, 2021 at 10:49:23AM -0700, Eric Biggers wrote:
> [ NOTE: this patchset is an RFC that isn't ready for merging yet because
>   it doesn't yet include the vendor-specific UFS or eMMC driver changes
>   needed to actually use the feature.  I.e., this patchset isn't
>   sufficient to actually use hardware-wrapped keys with upstream yet.
> 
>   For context, hardware-wrapped key support has been out-of-tree in the
>   Android kernels since early last year; upstreaming has been blocked on
>   hardware availability and support.  However, an SoC that supports this
>   feature (SM8350, a.k.a. Qualcomm Snapdragon 888) finally has been
>   publicly released and had basic SoC support upstreamed.  Also, some
>   other hardware will support the same feature soon.  So, things should
>   be progressing soon.  So while the driver changes are gotten into an
>   upstream-ready form, I wanted to get things started and give people a
>   chance to give early feedback on the plan for how the kernel will
>   support this type of hardware.]
> 
> This patchset adds framework-level support (i.e., block and fscrypt
> support) for hardware-wrapped keys when the inline encryption hardware
> supports them.  Hardware-wrapped keys are inline encryption keys that
> are wrapped (encrypted) by a key internal to the hardware.  Except at
> initial unlocking time, the wrapping key is an ephemeral, per-boot key.
> Hardware-wrapped keys can only be unwrapped (decrypted) by the hardware,
> e.g. when a key is programmed into a keyslot.  They are never visible to
> software in raw form, except optionally during key generation (the
> hardware supports importing keys as well as generating keys itself).
> 
> This feature protects the encryption keys from read-only compromises of
> kernel memory, such as that which can occur during a cold boot attack.
> It does this without limiting the number of keys that can be used, as
> would be the case with solutions that didn't use key wrapping.
> 
> The kernel changes to support this feature basically consist of changes
> to blk-crypto to allow a blk_crypto_key to be hardware-wrapped and to
> allow storage drivers to support hardware-wrapped keys, new block device
> ioctls for creating and preparing hardware-wrapped keys, and changes to
> fscrypt to allow the fscrypt master keys to be hardware-wrapped.
> 
> For full details, see the individual patches, especially the detailed
> documentation they add to Documentation/block/inline-encryption.rst and
> Documentation/filesystems/fscrypt.rst.
> 
> This patchset is organized as follows:
> 
> - Patch 1 adds the block support and documentation, excluding the ioctls
>   needed to get a key ready to be used in the first place.
> 
> - Patch 2 adds new block device ioctls for creating and preparing
>   hardware-wrapped keys.
> 
> - Patches 3-4 clean up the fscrypt documentation and key validation
>   logic.  These aren't specific to hardware-wrapped keys per se, so
>   these don't need to wait for the rest of the patches.
> 
> - Patch 5 adds the fscrypt support and documentation.
> 
> This patchset applies to v5.15-rc1 plus my other patchset
> "[PATCH v2 0/4] blk-crypto cleanups".  It can also be retrieved from tag
> "wrapped-keys-v2" of
> https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git.

I'd greatly appreciate any feedback on this patch series; I don't know whether
silence means everyone likes this, or everyone hates this, or no one cares :-)
(Or maybe no one is interested until driver changes are included?)

- Eric
