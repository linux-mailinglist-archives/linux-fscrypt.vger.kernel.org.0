Return-Path: <linux-fscrypt+bounces-316-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1D0909460
	for <lists+linux-fscrypt@lfdr.de>; Sat, 15 Jun 2024 01:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCD1E1C214BC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jun 2024 23:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716AC14830B;
	Fri, 14 Jun 2024 23:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p9QNOLLZ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77924481D0
	for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jun 2024 23:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718406071; cv=none; b=IuP3VWa8QA85+NROZxT1UndEd6f+XSF2krkre0BqYK/AsRyURSLG26Zrwekj3+qxGwhTEY37nQ63c37GnLC3tJkJ/gqXwDVej+P+eFc/4JWdGF37qB2bf7pGzcre+/urf9d8J7vRslozCtnib7o6QTwzZkFBqREVQBEYI9odt/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718406071; c=relaxed/simple;
	bh=cUn2ro5t8hvJdnUiLMEBcEs/sY4KPWEv4rettZXbmUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rjvM485zV1ZIYS+0tzL1Dk+LyWVRMs+PDT7iiCY7zMlsUFyXmngMMRP2UJHHItVmyPdcAgD1D3eWpvyGTRCJQdcHi6mhlLU4gHKiFSysAKPVQ+0/imH/g5XD4Ef8QiU0rgBkb255gQj3YJd+mLaXSHcFjec8wWIGiHqUZoM/TYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p9QNOLLZ; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dfefe1a9f01so3068302276.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jun 2024 16:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718406068; x=1719010868; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lgHV6L3eFSZdc43txkr9tWnMlInmAtTjrQiLaQo6Imo=;
        b=p9QNOLLZ0FgzaeEq12hMN3QIJSKVS8yvB7wmuIhrYsw09AIFjTxwBdfLhrOFCT6Kho
         6BybRjC61XlC1LkWPBII5ReUCUHiA/SVXerEsvxVieQd1CDFp5Jz2NRpzuJjUCLNEPpV
         o7kbY7hC/F/4rUyc0M7mc0mcV34qNn+yQwvJ4hbCZ+BDpRRU6OOPhybHuFmWO0qFpPUW
         X6qOzRVefS2OnS0gHofIqJMOmIx1E4hDn6Pd4GHKc4jvyWKR0nA+Rq5zGo7hs2bC9pe+
         9/Zgp2TRiZFz2wHWGN3bJlhIOWK16bBcjkVav0Ko9OOa8rphs4aD3793rKBYjCzjbHAz
         /JEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718406068; x=1719010868;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lgHV6L3eFSZdc43txkr9tWnMlInmAtTjrQiLaQo6Imo=;
        b=FZbThgBz246LupTpZJc/M3dihMmCXgxBPyP6ag4cSaMklmjwGv7Qfc9/iFdN4VXUbB
         KXLJ13l8lhtChaF0x3ruy3LXBc3uSoFPjSx1p9K22fhxGx+kw+leSkMbSQz/MjJaQegN
         JrOZ79FrXDK66PwFXc7E3XGExb1O96BB8TUPHbMLjAYG23xJ6YeFh3EeaJk2K9N+8Xze
         D5jJ0y0BEEClU4U0nxxpklLR5AWECnDg58O372mce6zF0fVZBkDez8r/vGNKoLSFv8uX
         J43LCNwbIhrz2IfrksWlpvUAPgVT7TJFj23okwSr6dCIArwQlB+TPb8+MZuU+lmz7uhN
         llmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXrdiFKSQT4Q/EgpAefXqs+BmwjtT1hg1eXvy2cWW5bMxzIQkw7DYkxi+b3oQMLHMCCA6NstG5you0fINsMu2VqSCqGOJrBiTaD8XjXvQ==
X-Gm-Message-State: AOJu0YwFUeACSIgvvalOFnn+z+iEvkUCrG3h0rTtoxSccrBgZrqwOQoK
	e7x3RFOHVyR5a2hCk95bpERam110KRwg4NvAWhrpumqYZqpScC+9Hjz/DHNwV/AlYl7+xul0IDt
	YOpblOmL+H27CoQgR1YSiWKzy0M0fzWEtIHf0Iw==
X-Google-Smtp-Source: AGHT+IHzlpm/VkF6w2lTOi1zI4/MusMO0PMLsXm+2gRujgsEeAH4uoTUkpth6NTMIWvVW4Wd1MYUzB+293S9EBj7Ni4=
X-Received: by 2002:a05:6902:701:b0:dfb:312:61c9 with SMTP id
 3f1490d57ef6-dff1548fbd5mr4437169276.52.1718406068229; Fri, 14 Jun 2024
 16:01:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611223419.239466-1-ebiggers@kernel.org> <20240611223419.239466-7-ebiggers@kernel.org>
In-Reply-To: <20240611223419.239466-7-ebiggers@kernel.org>
From: Sam Protsenko <semen.protsenko@linaro.org>
Date: Fri, 14 Jun 2024 18:00:57 -0500
Message-ID: <CAPLW+4kPAi+13C7t34XWW9ciAoYUebj5nz_EQY+RKhsT2ZpHnQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, Peter Griffin <peter.griffin@linaro.org>, 
	=?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 5:36=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Add support for Flash Memory Protector (FMP), which is the inline
> encryption hardware on Exynos and Exynos-based SoCs.
>
> Specifically, add support for the "traditional FMP mode" that works on
> many Exynos-based SoCs including gs101.  This is the mode that uses
> "software keys" and is compatible with the upstream kernel's existing
> inline encryption framework in the block and filesystem layers.  I plan
> to add support for the wrapped key support on gs101 at a later time.
>
> Tested on gs101 (specifically Pixel 6) by running the 'encrypt' group of
> xfstests on a filesystem mounted with the 'inlinecrypt' mount option.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/ufs/host/ufs-exynos.c | 219 +++++++++++++++++++++++++++++++++-
>  1 file changed, 218 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.=
c
> index 88d125d1ee3c..969c4eedbe2d 100644
> --- a/drivers/ufs/host/ufs-exynos.c
> +++ b/drivers/ufs/host/ufs-exynos.c
> @@ -6,10 +6,13 @@
>   * Author: Seungwon Jeon  <essuuj@gmail.com>
>   * Author: Alim Akhtar <alim.akhtar@samsung.com>
>   *
>   */
>
> +#include <asm/unaligned.h>
> +#include <crypto/aes.h>
> +#include <linux/arm-smccc.h>
>  #include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_address.h>
> @@ -1149,10 +1152,221 @@ static inline void exynos_ufs_priv_init(struct u=
fs_hba *hba,
>                 ufs->rx_sel_idx =3D 0;
>         hba->priv =3D (void *)ufs;
>         hba->quirks =3D ufs->drv_data->quirks;
>  }
>
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +
> +/*
> + * Support for Flash Memory Protector (FMP), which is the inline encrypt=
ion
> + * hardware on Exynos and Exynos-based SoCs.  The interface to this hard=
ware is
> + * not compatible with the standard UFS crypto.  It requires that encryp=
tion be
> + * configured in the PRDT using a nonstandard extension.
> + */
> +
> +enum fmp_crypto_algo_mode {
> +       FMP_BYPASS_MODE =3D 0,
> +       FMP_ALGO_MODE_AES_CBC =3D 1,
> +       FMP_ALGO_MODE_AES_XTS =3D 2,
> +};
> +enum fmp_crypto_key_length {
> +       FMP_KEYLEN_256BIT =3D 1,
> +};
> +#define FMP_DATA_UNIT_SIZE     SZ_4K
> +
> +/* This is the nonstandard format of PRDT entries when FMP is enabled. *=
/
> +struct fmp_sg_entry {
> +
> +       /*
> +        * This is the standard PRDT entry, but with nonstandard bitfield=
s in
> +        * the high bits of the 'size' field, i.e. the last 32-bit word. =
 When
> +        * these nonstandard bitfields are zero, the data segment won't b=
e
> +        * encrypted or decrypted.  Otherwise they specify the algorithm =
and key
> +        * length with which the data segment will be encrypted or decryp=
ted.
> +        */

Minor suggestion: create a kernel-doc comment for the structure and
pull all fields documentation there.

> +       struct ufshcd_sg_entry base;
> +
> +       /* The initialization vector (IV) with all bytes reversed */
> +       __be64 file_iv[2];
> +
> +       /*
> +        * The key with all bytes reversed.  For XTS, the two halves of t=
he key
> +        * are given separately and are byte-reversed separately.
> +        */
> +       __be64 file_enckey[4];
> +       __be64 file_twkey[4];
> +
> +       /* Unused */
> +       __be64 disk_iv[2];
> +       __be64 reserved[2];
> +};
> +
> +#define SMC_CMD_FMP_SECURITY           0xC2001810
> +#define SMC_CMD_SMU                    0xC2001850
> +#define SMC_CMD_FMP_SMU_RESUME         0xC2001860

Suggest to use ARM_SMCCC_CALL_VAL() macro to define above values.

> +#define SMU_EMBEDDED                   0
> +#define SMU_INIT                       0
> +#define CFG_DESCTYPE_3                 3
> +
> +static inline long exynos_smc(unsigned long cmd, unsigned long arg0,
> +                             unsigned long arg1, unsigned long arg2)
> +{
> +       struct arm_smccc_res res;
> +
> +       arm_smccc_smc(cmd, arg0, arg1, arg2, 0, 0, 0, 0, &res);
> +       return res.a0;
> +}

This wrapper looks like it was borrowed from the downstream Samsung
code. Not sure if it brings any value nowadays. Maybe it would be
clearer to just use arm_smccc_smc() directly and remove this wrapper?

> +
> +static void exynos_ufs_fmp_init(struct ufs_hba *hba)
> +{
> +       struct blk_crypto_profile *profile =3D &hba->crypto_profile;
> +       long ret;
> +
> +       /*
> +        * Check for the standard crypto support bit, since it's availabl=
e even
> +        * though the rest of the interface to FMP is nonstandard.
> +        *
> +        * This check should have the effect of preventing the driver fro=
m
> +        * trying to use FMP on old Exynos SoCs that don't have FMP.
> +        */
> +       if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
> +             MASK_CRYPTO_SUPPORT))
> +               return;
> +
> +       /*
> +        * This call (which sets DESCTYPE to 0x3 in the FMPSECURITY0 regi=
ster)
> +        * is needed to make the hardware use the larger PRDT entry size.
> +        */
> +       BUILD_BUG_ON(sizeof(struct fmp_sg_entry) !=3D 128);
> +       ret =3D exynos_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DES=
CTYPE_3);
> +       if (ret) {
> +               dev_warn(hba->dev,
> +                        "SMC_CMD_FMP_SECURITY failed on init: %ld.  Disa=
bling FMP support.\n",
> +                        ret);
> +               return;
> +       }
> +       ufshcd_set_sg_entry_size(hba, sizeof(struct fmp_sg_entry));
> +
> +       /*
> +        * This is needed to initialize FMP.  Without it, errors occur wh=
en
> +        * inline encryption is used.
> +        */
> +       ret =3D exynos_smc(SMC_CMD_SMU, SMU_INIT, SMU_EMBEDDED, 0);
> +       if (ret) {
> +               dev_err(hba->dev,
> +                       "SMC_CMD_SMU(SMU_INIT) failed: %ld.  Disabling FM=
P support.\n",
> +                       ret);
> +               return;
> +       }
> +
> +       /* Advertise crypto capabilities to the block layer. */
> +       ret =3D devm_blk_crypto_profile_init(hba->dev, profile, 0);
> +       if (ret) {
> +               /* Only ENOMEM should be possible here. */
> +               dev_err(hba->dev, "Failed to initialize crypto profile: %=
ld\n",
> +                       ret);
> +               return;
> +       }
> +       profile->max_dun_bytes_supported =3D AES_BLOCK_SIZE;
> +       profile->dev =3D hba->dev;
> +       profile->modes_supported[BLK_ENCRYPTION_MODE_AES_256_XTS] =3D
> +               FMP_DATA_UNIT_SIZE;
> +
> +       /* Advertise crypto support to ufshcd-core. */
> +       hba->caps |=3D UFSHCD_CAP_CRYPTO;
> +
> +       /* Advertise crypto quirks to ufshcd-core. */
> +       hba->quirks |=3D UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE |
> +                      UFSHCD_QUIRK_BROKEN_CRYPTO_ENABLE |
> +                      UFSHCD_QUIRK_KEYS_IN_PRDT;
> +
> +}
> +
> +static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
> +{
> +       long ret;
> +
> +       ret =3D exynos_smc(SMC_CMD_FMP_SECURITY, 0, SMU_EMBEDDED, CFG_DES=
CTYPE_3);
> +       if (ret)
> +               dev_err(hba->dev,
> +                       "SMC_CMD_FMP_SECURITY failed on resume: %ld\n", r=
et);
> +
> +       ret =3D exynos_smc(SMC_CMD_FMP_SMU_RESUME, 0, SMU_EMBEDDED, 0);
> +       if (ret)
> +               dev_err(hba->dev, "SMC_CMD_FMP_SMU_RESUME failed: %ld\n",=
 ret);
> +}
> +
> +static inline __be64 fmp_key_word(const u8 *key, int j)
> +{
> +       return cpu_to_be64(get_unaligned_le64(
> +                       key + AES_KEYSIZE_256 - (j + 1) * sizeof(u64)));
> +}
> +
> +/* Fill the PRDT for a request according to the given encryption context=
. */
> +static int exynos_ufs_fmp_fill_prdt(struct ufs_hba *hba,
> +                                   const struct bio_crypt_ctx *crypt_ctx=
,
> +                                   void *prdt, unsigned int num_segments=
)
> +{
> +       struct fmp_sg_entry *fmp_prdt =3D prdt;
> +       const u8 *enckey =3D crypt_ctx->bc_key->raw;
> +       const u8 *twkey =3D enckey + AES_KEYSIZE_256;
> +       u64 dun_lo =3D crypt_ctx->bc_dun[0];
> +       u64 dun_hi =3D crypt_ctx->bc_dun[1];
> +       unsigned int i;
> +
> +       /* If FMP wasn't enabled, we shouldn't get any encrypted requests=
. */
> +       if (WARN_ON_ONCE(!(hba->caps & UFSHCD_CAP_CRYPTO)))
> +               return -EIO;
> +
> +       /* Configure FMP on each segment of the request. */
> +       for (i =3D 0; i < num_segments; i++) {
> +               struct fmp_sg_entry *prd =3D &fmp_prdt[i];
> +               int j;
> +
> +               /* Each segment must be exactly one data unit. */
> +               if (prd->base.size !=3D cpu_to_le32(FMP_DATA_UNIT_SIZE - =
1)) {
> +                       dev_err(hba->dev,
> +                               "data segment is misaligned for FMP\n");
> +                       return -EIO;
> +               }
> +
> +               /* Set the algorithm and key length. */
> +               prd->base.size |=3D cpu_to_le32((FMP_ALGO_MODE_AES_XTS <<=
 28) |
> +                                             (FMP_KEYLEN_256BIT << 26));
> +
> +               /* Set the IV. */
> +               prd->file_iv[0] =3D cpu_to_be64(dun_hi);
> +               prd->file_iv[1] =3D cpu_to_be64(dun_lo);
> +
> +               /* Set the key. */
> +               for (j =3D 0; j < AES_KEYSIZE_256 / sizeof(u64); j++) {
> +                       prd->file_enckey[j] =3D fmp_key_word(enckey, j);
> +                       prd->file_twkey[j] =3D fmp_key_word(twkey, j);
> +               }
> +
> +               /* Increment the data unit number. */
> +               dun_lo++;
> +               if (dun_lo =3D=3D 0)
> +                       dun_hi++;
> +       }
> +       return 0;
> +}
> +
> +#else /* CONFIG_SCSI_UFS_CRYPTO */
> +
> +static void exynos_ufs_fmp_init(struct ufs_hba *hba)
> +{
> +}
> +
> +static void exynos_ufs_fmp_resume(struct ufs_hba *hba)
> +{
> +}
> +
> +#define exynos_ufs_fmp_fill_prdt NULL
> +
> +#endif /* !CONFIG_SCSI_UFS_CRYPTO */
> +
>  static int exynos_ufs_init(struct ufs_hba *hba)
>  {
>         struct device *dev =3D hba->dev;
>         struct platform_device *pdev =3D to_platform_device(dev);
>         struct exynos_ufs *ufs;
> @@ -1196,10 +1410,12 @@ static int exynos_ufs_init(struct ufs_hba *hba)
>                 goto out;
>         }
>
>         exynos_ufs_priv_init(hba, ufs);
>
> +       exynos_ufs_fmp_init(hba);
> +
>         if (ufs->drv_data->drv_init) {
>                 ret =3D ufs->drv_data->drv_init(dev, ufs);
>                 if (ret) {
>                         dev_err(dev, "failed to init drv-data\n");
>                         goto out;
> @@ -1430,11 +1646,11 @@ static int exynos_ufs_resume(struct ufs_hba *hba,=
 enum ufs_pm_op pm_op)
>
>         if (!ufshcd_is_link_active(hba))
>                 phy_power_on(ufs->phy);
>
>         exynos_ufs_config_smu(ufs);
> -
> +       exynos_ufs_fmp_resume(hba);
>         return 0;
>  }
>
>  static int exynosauto_ufs_vh_link_startup_notify(struct ufs_hba *hba,
>                                                  enum ufs_notify_change_s=
tatus status)
> @@ -1696,10 +1912,11 @@ static const struct ufs_hba_variant_ops ufs_hba_e=
xynos_ops =3D {
>         .setup_xfer_req                 =3D exynos_ufs_specify_nexus_t_xf=
er_req,
>         .setup_task_mgmt                =3D exynos_ufs_specify_nexus_t_tm=
_req,
>         .hibern8_notify                 =3D exynos_ufs_hibern8_notify,
>         .suspend                        =3D exynos_ufs_suspend,
>         .resume                         =3D exynos_ufs_resume,
> +       .fill_crypto_prdt               =3D exynos_ufs_fmp_fill_prdt,
>  };
>
>  static struct ufs_hba_variant_ops ufs_hba_exynosauto_vh_ops =3D {
>         .name                           =3D "exynosauto_ufs_vh",
>         .init                           =3D exynosauto_ufs_vh_init,
> --
> 2.45.2
>
>

