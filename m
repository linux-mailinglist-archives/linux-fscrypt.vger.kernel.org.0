Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1151C98B0
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgEGSEi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 14:04:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728338AbgEGSEi (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 14:04:38 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F5E2145D;
        Thu,  7 May 2020 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588874677;
        bh=HOvo/RmXoD5byaAGPG/CBIZ+OxBl1+gN6PhJXjFXH7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BfOCs51UgV5qmMXcDPdBfQv8Oy4J6tA84JuHx95Nm8Ds2BY5RM2vnKRxzmuZdt+wo
         2sw4UpkvtBHFoVEYxFI2R8/IUDCTNZqglUmb37vy5V9TRmBbEbzNkhGE1QRMdBvZpC
         Ho+jp1WEr+vPL6H67snKnAtTSQCmA5mmZ3HkPwss=
Date:   Thu, 7 May 2020 11:04:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Thara Gopinath <thara.gopinath@linaro.org>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [RFC PATCH v4 4/4] scsi: ufs-qcom: add Inline Crypto Engine
 support
Message-ID: <20200507180435.GB236103@gmail.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Thara,

On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
> 
> 
> On 5/1/20 12:51 AM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> > 
> > The standards-compliant parts, such as querying the crypto capabilities
> > and enabling crypto for individual UFS requests, are already handled by
> > ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> > However, ICE requires vendor-specific init, enable, and resume logic,
> > and it requires that keys be programmed and evicted by vendor-specific
> > SMC calls.  Make the ufs-qcom driver handle these details.
> > 
> > I tested this on Dragonboard 845c, which is a publicly available
> > development board that uses the Snapdragon 845 SoC and runs the upstream
> > Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> > phones.  This testing included (among other things) verifying that the
> > expected ciphertext was produced, both manually using ext4 encryption
> > and automatically using a block layer self-test I've written.
> Hello Eric,
> 
> I am interested in testing out this series on 845, 855 and if possile on 865
> platforms. Can you give me some more details about your testing please.
> 

Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.

A basic manual test would be:

1. Build a kernel with:

	CONFIG_BLK_INLINE_ENCRYPTION=y
	CONFIG_FS_ENCRYPTION=y
	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y

2. Create a filesystem with 'mkfs.ext4 -O encrypt' or 'mkfs.f2fs -O encrypt'

3. Mount the filesystem with '-o inlinecrypt'

4. Create an encrypted directory and copy some files into it.

5. Unmount the filesystem, and mount it *without* '-o inlinecrypt'.

6. Verify that the files match the originals.

If you're using a Linux distro like Debian, then creating an encrypted directory
is most easily done using the userspace tool https://github.com/google/fscrypt.

If instead your testing platform is Android, then instead of the above manual
test you can configure Android's encryption use the hardware and then run
VtsKernelEncryptionTest.  See the directions at
https://source.android.com/security/encryption/file-based.

Note that this patchset only includes the device tree support for Snapdragon
845.  For 855 and 865 you'd need to add the device tree support.

There are other ways this can be tested too, like xfstests, or my experimental
blk-crypto-selftest.  Let me know if you want any other suggestions.

> > +/*
> > + * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requires
> > + * vendor-specific SCM calls for this; it doesn't support the standard way.
> > + */
> > +int ufs_qcom_ice_program_key(struct ufs_hba *hba,
> > +			     const union ufs_crypto_cfg_entry *cfg, int slot)
> > +{
> > +	union ufs_crypto_cap_entry cap;
> > +	union {
> > +		u8 bytes[AES_256_XTS_KEY_SIZE];
> > +		u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
> > +	} key;
> > +	int i;
> > +	int err;
> Should there not be a check for here ?
> 	if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
> 		return 0;
> 

(Please trim your replies appropriately; I almost missed this part!)

No, that's not necessary because this function is only called if we installed a
blk_keyslot_manager to the UFS host (thus exposing its crypto support to the
rest of the kernel).  We only do that if the driver sets UFSHCD_CAP_CRYPTO.

Likewise, we don't need to check for UFSHCD_CAP_CRYPTO in
ufshcd_crypto_keyslot_program(), ufshcd_crypto_keyslot_evict(), etc.

- Eric
