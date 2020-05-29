Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251151E846D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 May 2020 19:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE2RN2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 May 2020 13:13:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:33576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE2RN2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 May 2020 13:13:28 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82A6D20723;
        Fri, 29 May 2020 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590772408;
        bh=BbBe82lF+6Tr+noUC4bXnOHTzzVUPB37RrcOhBm7fTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O/M+2wKz/pSqjaCIRdl+JuWbLWuiMrolQuDUxLdIuEg059L8ejThnasSmQryOv0Un
         OVrrBnQkygJAOOWBAGzd6GlsV556VZBuQeArM7S3GtKsF2OBAoHFFZ1GfyBmOZ0psj
         IjCk52zdCHQk2+i0RFgK79raNAq9Cyj0xRFbx7+E=
Date:   Fri, 29 May 2020 10:13:26 -0700
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
Message-ID: <20200529171326.GA82398@gmail.com>
References: <20200501045111.665881-1-ebiggers@kernel.org>
 <20200501045111.665881-5-ebiggers@kernel.org>
 <31fa95e5-7757-96ae-2e86-1f54959e3a6c@linaro.org>
 <20200507180435.GB236103@gmail.com>
 <20200507180838.GC236103@gmail.com>
 <40600d42-dfa9-b60c-6ce8-0eda6bdf7ddf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40600d42-dfa9-b60c-6ce8-0eda6bdf7ddf@linaro.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 29, 2020 at 11:54:18AM -0400, Thara Gopinath wrote:
> On 5/7/20 2:08 PM, Eric Biggers wrote:
> > On Thu, May 07, 2020 at 11:04:35AM -0700, Eric Biggers wrote:
> > > Hi Thara,
> > > 
> > > On Thu, May 07, 2020 at 08:36:58AM -0400, Thara Gopinath wrote:
> > > > 
> > > > 
> > > > On 5/1/20 12:51 AM, Eric Biggers wrote:
> > > > > From: Eric Biggers <ebiggers@google.com>
> > > > > 
> > > > > Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
> > > > > 
> > > > > The standards-compliant parts, such as querying the crypto capabilities
> > > > > and enabling crypto for individual UFS requests, are already handled by
> > > > > ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> > > > > However, ICE requires vendor-specific init, enable, and resume logic,
> > > > > and it requires that keys be programmed and evicted by vendor-specific
> > > > > SMC calls.  Make the ufs-qcom driver handle these details.
> > > > > 
> > > > > I tested this on Dragonboard 845c, which is a publicly available
> > > > > development board that uses the Snapdragon 845 SoC and runs the upstream
> > > > > Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> > > > > phones.  This testing included (among other things) verifying that the
> > > > > expected ciphertext was produced, both manually using ext4 encryption
> > > > > and automatically using a block layer self-test I've written.
> > > > Hello Eric,
> > > > 
> > > > I am interested in testing out this series on 845, 855 and if possile on 865
> > > > platforms. Can you give me some more details about your testing please.
> > > > 
> > > 
> > > Great!  You can test this with fscrypt, a.k.a. ext4 or f2fs encryption.
> > > 
> > > A basic manual test would be:
> > > 
> > > 1. Build a kernel with:
> > > 
> > > 	CONFIG_BLK_INLINE_ENCRYPTION=y
> > > 	CONFIG_FS_ENCRYPTION=y
> > > 	CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y
> > 
> > Sorry, I forgot: 'CONFIG_SCSI_UFS_CRYPTO=y' is needed too.
> 
> Hi Eric,
> 
> I tested this manually on db845c, sm8150-mtp and sm8250-mtp.(I added the dts
> file entries for 8150 and 8250).
> 
> I also ran OsBench test case createfiles[1] on the above platforms.
> Following are the results on a non encrypted and encrypted directory on the
> same file system(lower the number better)
> 
> 			8250-MTP	8150-MTP	DB845
> 
> nonencrypt_dir(us) 	55.3108954	26.8323124    69.5709552
> encrypt_dir(us) 	70.0214426	37.5411254    92.3818296
> 
> 
> 
> 1. https://github.com/mbitsnbites/osbench/blob/master/README.md
> 

Great, thanks for testing.

Note that the benchmark you ran (creating many small files, then deleting them)
mostly tests the performance of filenames encryption and directory operations,
not file contents encryption.  Inline encryption is only used for file contents.

In fact, since that benchmark doesn't sync the files before deleting them, there
is no guarantee that any file contents are actually written to disk, and hence
no guarantee that inline encryption got used at all.

It would be more relevant to test the performance of reading/writing file data.

Also, did you try doing any correctness tests?  (See what I suggested earlier.)

- Eric
