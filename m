Return-Path: <linux-fscrypt+bounces-325-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1C3691F023
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:29:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84F30286C77
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A5913D8BA;
	Tue,  2 Jul 2024 07:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NrFXqIFB"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CDD133987;
	Tue,  2 Jul 2024 07:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905333; cv=none; b=bewXNPBcowgUTQkRJ9E/EUA1J9qMoDUeWUth+NIlfGV50NoiPG5TqrQtbIlgbhsFwXEhBQkNlU40KcedzoH493sXTsY6JVLNedEO4gl2xxHTFtsY1bjcUJO6Yg4321DQAGlcRLefzv4lkyVq7a7HOBG+1nFV2146QWJWjLkZWUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905333; c=relaxed/simple;
	bh=fe1WusoWTQnTd1P5u/jAG7TOsY/59WcKkHZBjncyvbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OJV5mjx/vj5F2/SeCM/+FwyUXLPwbZHSp8oqj7G+VsPNz54gfN7EIY8qMY02hCS+g/u7uVhMb8QiY1yRKxzhTiQeJWl2TosCMl0u7W++DwFkAOm2KnJV7O0MlUm8p15PaZFNmySppoN6tbmTfVTGH2QcHZfXqjKFfoHUHYnaC/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NrFXqIFB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33004C32781;
	Tue,  2 Jul 2024 07:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905333;
	bh=fe1WusoWTQnTd1P5u/jAG7TOsY/59WcKkHZBjncyvbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NrFXqIFBLL042fXbIeBQbLphGByU3q3r7cg8DM7DBTCsK62x+zDDRNvB96UN8REsc
	 57BVckTTKnGVT1AvbeXENdEYh+cORKtDO/jV+70yXZui+EF/4CLipPxoG3Spgeq2V2
	 miTVE1zz1Wb8vjOVvRsOlKu/H3KHcBH2VY8JmFYCtbcrzp/NHqAXboFaaA2g8wVjCC
	 eZmCGRrXkWN60bflkdVybFEHyqHmidfrRIKjIOh64c3ngfYKdopdgCqQPKNBKiTYQU
	 v7ECx9ORbQTWyD5rtzDTksj8Rt2xHRaTyMTKESsZ/DqJzFiUzfDjGY2mtXS+0EBpzG
	 CI40mA+eaM3zQ==
Date: Tue, 2 Jul 2024 00:28:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Message-ID: <20240702072851.GB121190@sol.localdomain>
References: <20240611223419.239466-1-ebiggers@kernel.org>
 <20240611223419.239466-7-ebiggers@kernel.org>
 <CAPLW+4kPAi+13C7t34XWW9ciAoYUebj5nz_EQY+RKhsT2ZpHnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPLW+4kPAi+13C7t34XWW9ciAoYUebj5nz_EQY+RKhsT2ZpHnQ@mail.gmail.com>

On Fri, Jun 14, 2024 at 06:00:57PM -0500, Sam Protsenko wrote:
> On Tue, Jun 11, 2024 at 5:36 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > From: Eric Biggers <ebiggers@google.com>
> >
> > Add support for Flash Memory Protector (FMP), which is the inline
> > encryption hardware on Exynos and Exynos-based SoCs.
> >
> > Specifically, add support for the "traditional FMP mode" that works on
> > many Exynos-based SoCs including gs101.  This is the mode that uses
> > "software keys" and is compatible with the upstream kernel's existing
> > inline encryption framework in the block and filesystem layers.  I plan
> > to add support for the wrapped key support on gs101 at a later time.
> >
> > Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> > xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  drivers/ufs/host/ufs-exynos.c | 219 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 218 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
> > index 88d125d1ee3c..969c4eedbe2d 100644
> > --- a/drivers/ufs/host/ufs-exynos.c
> > +++ b/drivers/ufs/host/ufs-exynos.c
> > @@ -6,10 +6,13 @@
> >   * Author: Seungwon Jeon  <essuuj@gmail.com>
> >   * Author: Alim Akhtar <alim.akhtar@samsung.com>
> >   *
> >   */
> >
> > +#include <asm/unaligned.h>
> > +#include <crypto/aes.h>
> > +#include <linux/arm-smccc.h>
> >  #include <linux/clk.h>
> >  #include <linux/delay.h>
> >  #include <linux/module.h>
> >  #include <linux/of.h>
> >  #include <linux/of_address.h>
> > @@ -1149,10 +1152,221 @@ static inline void exynos_ufs_priv_init(struct ufs_hba *hba,
> >                 ufs->rx_sel_idx = 0;
> >         hba->priv = (void *)ufs;
> >         hba->quirks = ufs->drv_data->quirks;
> >  }
> >
> > +#ifdef CONFIG_SCSI_UFS_CRYPTO
> > +
> > +/*
> > + * Support for Flash Memory Protector (FMP), which is the inline encryption
> > + * hardware on Exynos and Exynos-based SoCs.  The interface to this hardware is
> > + * not compatible with the standard UFS crypto.  It requires that encryption be
> > + * configured in the PRDT using a nonstandard extension.
> > + */
> > +
> > +enum fmp_crypto_algo_mode {
> > +       FMP_BYPASS_MODE = 0,
> > +       FMP_ALGO_MODE_AES_CBC = 1,
> > +       FMP_ALGO_MODE_AES_XTS = 2,
> > +};
> > +enum fmp_crypto_key_length {
> > +       FMP_KEYLEN_256BIT = 1,
> > +};
> > +#define FMP_DATA_UNIT_SIZE     SZ_4K
> > +
> > +/* This is the nonstandard format of PRDT entries when FMP is enabled. */
> > +struct fmp_sg_entry {
> > +
> > +       /*
> > +        * This is the standard PRDT entry, but with nonstandard bitfields in
> > +        * the high bits of the 'size' field, i.e. the last 32-bit word.  When
> > +        * these nonstandard bitfields are zero, the data segment won't be
> > +        * encrypted or decrypted.  Otherwise they specify the algorithm and key
> > +        * length with which the data segment will be encrypted or decrypted.
> > +        */
> 
> Minor suggestion: create a kernel-doc comment for the structure and
> pull all fields documentation there.
> 
> > +       struct ufshcd_sg_entry base;
> > +
> > +       /* The initialization vector (IV) with all bytes reversed */
> > +       __be64 file_iv[2];
> > +
> > +       /*
> > +        * The key with all bytes reversed.  For XTS, the two halves of the key
> > +        * are given separately and are byte-reversed separately.
> > +        */
> > +       __be64 file_enckey[4];
> > +       __be64 file_twkey[4];
> > +
> > +       /* Unused */
> > +       __be64 disk_iv[2];
> > +       __be64 reserved[2];
> > +};
> > +
> > +#define SMC_CMD_FMP_SECURITY           0xC2001810
> > +#define SMC_CMD_SMU                    0xC2001850
> > +#define SMC_CMD_FMP_SMU_RESUME         0xC2001860
> 
> Suggest to use ARM_SMCCC_CALL_VAL() macro to define above values.
> 
> > +#define SMU_EMBEDDED                   0
> > +#define SMU_INIT                       0
> > +#define CFG_DESCTYPE_3                 3
> > +
> > +static inline long exynos_smc(unsigned long cmd, unsigned long arg0,
> > +                             unsigned long arg1, unsigned long arg2)
> > +{
> > +       struct arm_smccc_res res;
> > +
> > +       arm_smccc_smc(cmd, arg0, arg1, arg2, 0, 0, 0, 0, &res);
> > +       return res.a0;
> > +}
> 
> This wrapper looks like it was borrowed from the downstream Samsung
> code. Not sure if it brings any value nowadays. Maybe it would be
> clearer to just use arm_smccc_smc() directly and remove this wrapper?
> 

All done in v2.  Thanks.

- Eric

