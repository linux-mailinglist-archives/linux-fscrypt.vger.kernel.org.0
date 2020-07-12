Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF7A21C84C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2020 11:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGLJlk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 12 Jul 2020 05:41:40 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:24376 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728112AbgGLJlj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 12 Jul 2020 05:41:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594546899; x=1626082899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TWLCOkAoJqzgsOv4/0zG6s7pri8EYQ0KThKfnk20D7A=;
  b=aBUnE1vlf5l+0/Ud1Jc6zhtAkD3IiceWY5aK828CjByeyJVpkmzn94KD
   5M7BcT3EbFE4C+7TlJptcBXxbQACHSobZz6VZBrBOFrSSkV9xNTjYRXof
   So7mOoyMbCgdvu2AxaIJ8gEVumNOLNR0v6axrNlDqam0E/ZZFp9UrkY19
   r0ShqFvUp/S4AioRhQWUezEsF7IEW56J6EoH3NAO/b68DR5XOIV/fIp6+
   MmSz/VEekYoLJR/6w6YhDblL40/V6u6IlOdA5LRXvQyysEk9hXXBxcGNc
   KiRwPXQHhzwU9M3PBriEyFfh3BgKqNlMv4pThfgewelFzm9/6yb1LLdME
   A==;
IronPort-SDR: ITrKIsWmcGQIQs0lm12vUQD16dbru0gGILClKN8ty5AX8Z+wkb0wOkyiWsGGLkPGz8lvD/w4c6
 m4IgJJYB7b4fZhiWikCXY0EkkCSkVKnI2Max72EUApP0knlNzX4bMz0+ZUeyGsC0xTwj5UM3DR
 PKiHHVstEZEfpwUYT33H9b2PoFT2O/mlOj1DMD9s7UKSJqOgPpr7uGHPueRSx8P60aheXfA2CU
 /VSaohGJq0u6dqQvbGQJvtns/+XUiXsiDu7EU/GlyX24R9/+Rj0jodNDEfi7njo9gtvmwOhcZW
 rhA=
X-IronPort-AV: E=Sophos;i="5.75,343,1589212800"; 
   d="scan'208";a="142391526"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 17:41:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0asMKykCgA/rArEEru63qvqLUDdkhRdvBwY624xQiQ4eBVdvQquxHsKNCVBuC0kDWFMQR2Fe7CkElyryg4gWZH0zoCs5QUtby+SkJDZLX+6DHInRXW2qizDGojUg86Ye75d3t11jHgNWwrMhtveK+pIRKWRdQaUb5lo2vgwEbccbnuNWTUh5m50Erhbsko8SZBTHvcxmOQ0xoEyKaptS0fH/NPOIJcuJT6gEcSO20pCK990FWrMwp4cLPLMCnE73dMfWz0l7KPXRqb1hudOMLCZtyEWq8H3KP66YUiS1q/6yHHwub0yv9pWDW1XHNR/3stLe4Bxh2m2dzr5I4fvsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjRhxVrviW0ZjW+E3sENHfJqmgsKinJ26ostQZsZniE=;
 b=ADi/xXK2PTdmtr3dp88FnSCG9QIKc12TC8p+mS4yuVjdOIJc43Qt/SKDOMCxCYlqObQRnT9SOt5Uxb89gC+8UJO43CwbFhoJtgWO7cwSus5msytqdjQLPJutViFVKmCbUElTe2I0VvLnVhMZtVYHBs5+63ABkWJ6lP+qEmRShpR2ooie2axZzp4GVkBC7fpLfr1KIpXCpQNTn0wqVDyFDX4cjFn21+THyfQ6pF1MWMBXBxntImVFmt4ulqSJtLgj/vjMuO71hp8KFY7TEK5QM33mZMyyy8akz2eOz0911nUlfwwb7vDW7o2pXX9UxldxVdrIkY3xxjXJ9LNHtb6jnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjRhxVrviW0ZjW+E3sENHfJqmgsKinJ26ostQZsZniE=;
 b=M1LNXWxUrvEGc9JsgRjbeUU1tI0agfzqnF3rQeJIfZmjlaHMm5cQFDzgScY//AUUXp9aYwC+RrTaSkysWY7YvghIm+wSMRuH0h8S1XkRA6zIFrArqY+L6LxfDo4uJUmk61M2ahjq/bGsR2LAzdV7EBYKCuJvzcZdS2e1obrH1WE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4190.namprd04.prod.outlook.com (2603:10b6:805:32::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sun, 12 Jul
 2020 09:41:36 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 09:41:36 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: RE: [PATCH v6 4/5] scsi: ufs: add program_key() variant op
Thread-Topic: [PATCH v6 4/5] scsi: ufs: add program_key() variant op
Thread-Index: AQHWVorISQRdFJhEYEOECulQbwj946kDs/nw
Date:   Sun, 12 Jul 2020 09:41:36 +0000
Message-ID: <SN6PR04MB4640C1E3EFD1F55CF64054DCFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-5-ebiggers@kernel.org>
In-Reply-To: <20200710072013.177481-5-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 889c6874-1b4f-45b7-6532-08d82647c504
x-ms-traffictypediagnostic: SN6PR04MB4190:
x-microsoft-antispam-prvs: <SN6PR04MB4190E1CCC3274CBD22D3FF15FC630@SN6PR04MB4190.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WAvkeMH0ZkOgOrEgrDQYVHiiH7Ad1f5HwS+8p7F3KsAIYlS1vB+pI2JezbArBbGF7oIps288/FnB+V9mC2LHYdTUTWRJuYLgmXUQ0IOwXBl9CeCarteErcD5B0KpfOq7Xj3upPVBLp8LLJ9kMlZxGzKq1dPH8NhmG5XuufKDufeiQ6yt4pqnynuOVlLTC3UFMnkasPaElRAlCrcNM89EPLCsqeRDR7MbpFpIMbgeJQjUA/DMmlx93ok2scDtS1j/h8Vr+qslTZ3E0IVbWeeKXXe3Z48irAQrHVdbEsHX3x+oQsSVjlmFq00shaqc+JpDZLTYhM1NGwhMwipMDVeNgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39850400004)(396003)(376002)(5660300002)(9686003)(2906002)(55016002)(8936002)(6506007)(110136005)(86362001)(8676002)(33656002)(83380400001)(54906003)(66476007)(66446008)(186003)(71200400001)(66946007)(478600001)(7696005)(52536014)(26005)(76116006)(316002)(64756008)(66556008)(4326008)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: DYMRje0lzA+2Wedwb+g8xsmYpQ4GJh5dxxat/C5BLSZiWkSFTCHFTctycbZ4HpL33Vo5b1FLI9Tf+aEOOeLmB3e/d/fv2qhUrr2gbqbVzCwFbf7JbmgQMP1STu0+UUDJTxehu8NDGT6JjToloA0Rm/K5MHFIxH+0lhR0IMA51dH07dA7lHkK/9Nnt8yES+soMUqdoxwyQYNVkdzwavipSOa+YL8m9scZnJWJvDuv3twV0pgDoMGuUPS+aOGyOKr0oxWlpbECFrFZDs9n1TEcWaTrvKWeQuzVdAxSZYGHDd0AXJFbF+ZlFjC1jYv14q6jJkp6QoGLrX1jXxbFPSOR1cIPob1xx06HjoaoU4OqiC/a6yI/YV+rJCZJn1AgjTD7gIK0A4k4OQJyFSHL7qqjCa+50sdvMo4cbn7KkJCnNDeNmL06EpF/VJS9rDGY1agmlGylWcVZh5LF8eoYQSi5LgacYE+pELCS4yl/x3vEDcU=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889c6874-1b4f-45b7-6532-08d82647c504
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2020 09:41:36.2078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 29e33exZek1WccGNYE7Tqpzr0TPndWC9E4WpPkHmSJR1hpiYcSu2k2zB9t3rVmtBE2l7jxcw5YeCZVSl5EG9vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4190
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

=20
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> On Snapdragon SoCs, the Linux kernel isn't permitted to directly access
> the standard UFS crypto configuration registers.  Instead, programming
> and evicting keys must be done through vendor-specific SMC calls.
>=20
> To support this hardware, add a ->program_key() method to
> 'struct ufs_hba_variant_ops'.  This allows overriding the UFS standard
> key programming / eviction procedure.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufshcd-crypto.c | 27 +++++++++++++++++----------
>  drivers/scsi/ufs/ufshcd.h        |  3 +++
>  2 files changed, 20 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/scsi/ufs/ufshcd-crypto.c b/drivers/scsi/ufs/ufshcd-c=
rypto.c
> index 98ff87c38aa7..d2edbd960ebf 100644
> --- a/drivers/scsi/ufs/ufshcd-crypto.c
> +++ b/drivers/scsi/ufs/ufshcd-crypto.c
> @@ -17,14 +17,20 @@ static const struct ufs_crypto_alg_entry {
>         },
>  };
>=20
> -static void ufshcd_program_key(struct ufs_hba *hba,
> -                              const union ufs_crypto_cfg_entry *cfg,
> -                              int slot)
> +static int ufshcd_program_key(struct ufs_hba *hba,
> +                             const union ufs_crypto_cfg_entry *cfg, int =
slot)
>  {
>         int i;
>         u32 slot_offset =3D hba->crypto_cfg_register + slot * sizeof(*cfg=
);
> +       int err =3D 0;
>=20
>         ufshcd_hold(hba, false);
> +
> +       if (hba->vops && hba->vops->program_key) {
> +               err =3D hba->vops->program_key(hba, cfg, slot);
> +               goto out;
> +       }
> +
>         /* Ensure that CFGE is cleared before programming the key */
>         ufshcd_writel(hba, 0, slot_offset + 16 * sizeof(cfg->reg_val[0]))=
;
>         for (i =3D 0; i < 16; i++) {
> @@ -37,7 +43,9 @@ static void ufshcd_program_key(struct ufs_hba *hba,
>         /* Dword 16 must be written last */
>         ufshcd_writel(hba, le32_to_cpu(cfg->reg_val[16]),
>                       slot_offset + 16 * sizeof(cfg->reg_val[0]));
> +out:
>         ufshcd_release(hba);
> +       return err;
>  }
>=20
>  static int ufshcd_crypto_keyslot_program(struct blk_keyslot_manager *ksm=
,
> @@ -52,6 +60,7 @@ static int ufshcd_crypto_keyslot_program(struct
> blk_keyslot_manager *ksm,
>         int i;
>         int cap_idx =3D -1;
>         union ufs_crypto_cfg_entry cfg =3D { 0 };
> +       int err;
>=20
>         BUILD_BUG_ON(UFS_CRYPTO_KEY_SIZE_INVALID !=3D 0);
>         for (i =3D 0; i < hba->crypto_capabilities.num_crypto_cap; i++) {
> @@ -79,13 +88,13 @@ static int ufshcd_crypto_keyslot_program(struct
> blk_keyslot_manager *ksm,
>                 memcpy(cfg.crypto_key, key->raw, key->size);
>         }
>=20
> -       ufshcd_program_key(hba, &cfg, slot);
> +       err =3D ufshcd_program_key(hba, &cfg, slot);
>=20
>         memzero_explicit(&cfg, sizeof(cfg));
> -       return 0;
> +       return err;
>  }
>=20
> -static void ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
> +static int ufshcd_clear_keyslot(struct ufs_hba *hba, int slot)
>  {
>         /*
>          * Clear the crypto cfg on the device. Clearing CFGE
> @@ -93,7 +102,7 @@ static void ufshcd_clear_keyslot(struct ufs_hba *hba,
> int slot)
>          */
>         union ufs_crypto_cfg_entry cfg =3D { 0 };
>=20
> -       ufshcd_program_key(hba, &cfg, slot);
> +       return ufshcd_program_key(hba, &cfg, slot);
>  }
>=20
>  static int ufshcd_crypto_keyslot_evict(struct blk_keyslot_manager *ksm,
> @@ -102,9 +111,7 @@ static int ufshcd_crypto_keyslot_evict(struct
> blk_keyslot_manager *ksm,
>  {
>         struct ufs_hba *hba =3D container_of(ksm, struct ufs_hba, ksm);
>=20
> -       ufshcd_clear_keyslot(hba, slot);
> -
> -       return 0;
> +       return ufshcd_clear_keyslot(hba, slot);
>  }
>=20
>  bool ufshcd_crypto_enable(struct ufs_hba *hba)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 656c0691c858..b2ef18f1b746 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -281,6 +281,7 @@ struct ufs_pwr_mode_info {
>   * @dbg_register_dump: used to dump controller debug information
>   * @phy_initialization: used to initialize phys
>   * @device_reset: called to issue a reset pulse on the UFS device
> + * @program_key: program or evict an inline encryption key
>   */
>  struct ufs_hba_variant_ops {
>         const char *name;
> @@ -314,6 +315,8 @@ struct ufs_hba_variant_ops {
>         void    (*config_scaling_param)(struct ufs_hba *hba,
>                                         struct devfreq_dev_profile *profi=
le,
>                                         void *data);
> +       int     (*program_key)(struct ufs_hba *hba,
> +                              const union ufs_crypto_cfg_entry *cfg, int=
 slot);
>  };
>=20
>  /* clock gating state  */
> --
> 2.27.0

