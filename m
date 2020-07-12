Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23FBF21C81C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2020 10:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728354AbgGLInA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 12 Jul 2020 04:43:00 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:4578 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725974AbgGLIm7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 12 Jul 2020 04:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594543383; x=1626079383;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uLsodbJ+XHaYgLitSGxh2UGzhbGzGL0tJzIdWlYPLrc=;
  b=U/tFy6Qp/vFbY8JfBL5ypI2j+8DiHt2lk6Yc4+MJmjBxEimgRaoAO2Ze
   gcamPBQePGBwSpC0gGTWbPC4lBhBMhiOGAe7l0NkRUbh8LhIJO5Gqa/AG
   Die7m2YcvY6cR5Sflidn30SpcOZbRy7/cxGI4TSn7UCYXOzVk4SxEVmSC
   yb8FuuLOz4ebZf/EOOiLPd0V7Jo12j/Zu1i0XUrMf7ny2C3XI5UX2HFjg
   7zvD3d/if+tcCRgbkDS2M8dHXMR1oYAPPgTBSXFomWf62RXeUJEAZipqw
   nf1i3PMipSMCB3RBqAf0bNWMv2NdOdPKRbrZOwv3xTkz21NffT7he0kUT
   Q==;
IronPort-SDR: qgeMVIWSpRv3q/NLb6pt9V0l+Fd4bAUyjO/oK+666yhWGF0kzEeHDLrz+wC4crO/2sqXlfORhG
 9EcFh8T1KGGdg/Ey+kI+I6N/xHoQsZAFRu9QLYPyFFNcY5HBS1xgx9JPAEI0LynVWtIKtQ+gqe
 ST++eHB4IS1PziMtzq3WgT2X2YCgrrpnLYXUHlpwOnQmRMgVhZdnEIYgGOb9F1dw53Rv3dBnlY
 Jun26IG3sLbd8U3N2M7GAKBXVfN+2lpa46YGqtoCkaM+5rr9+0kdgcOwuzHkWH+8/InIXNihAJ
 Q+k=
X-IronPort-AV: E=Sophos;i="5.75,342,1589212800"; 
   d="scan'208";a="245261775"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 16:43:00 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLJIf945+eWeaclJrCRLfaOoHMVFYikVRQySNsBKTdTYFJO/ZhzscxEV8pRxZXARXEpIu1Ah5aVPbFXbteLMYT3ZDXOMzeHfho13iljWn9uBVghtxslJYzsz/iXl7tE+09MqFBtTtq07zowKbddXQnyPcwOC4YGBw48bowQaNu73rAet+2Jy5zHCawffKqhGzx6rULPHUASUCp41KzgKvr7n1mEVsR1v+90U6lemDz5ZotDvepiKBY+3e8u/H+SEnhv+jbM4S5T1rD8p+2HlhXM64Ogg6tzeMSV4agLhYXkhF+6kBkI4/t4bowBoN916trSyLbOV4Bt3I16Mi/OHwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lm9f1RWuYF+3uPBp1vohelqN2ZeyPDMSoOEVxLn6Z4=;
 b=TEI49+pRd2WGDMbiiaeeUwY65wc/IfJT24knnodsoqlljperpUAQTTHW90amWGkBqtDt4YS6kaR5NXlT3zgrGSaielgC8UMmK0j2RysJcZXbMNeQoB9lBkxwXVcRVz3Bjyk0xVhio97EHdhryxVRTQOOKmPYjfOy5EorulIwOesAZ51NV8iwGo0H/SF3D0JICQM5H/7KDX94fqfSb4XR36ZjyeDLRS1M71YljQPizIZ+SKdj5e0iG74UHFHZ4nT+2/TwcWbVs2raJq4Avz2C8+zzBbC53Arj1thzbVA54ilgALxFEMw23TcypD0KTk4a3n6sdQ9m+H91kTOVKqIlwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Lm9f1RWuYF+3uPBp1vohelqN2ZeyPDMSoOEVxLn6Z4=;
 b=L+s59pajbUHiIncr3fW4oHeyDKS0dpbnPaab5rNG/t+eyFdbyvq1Oh3mSuRg00AaTStBFQfOy+Ppc1QmhpE0JJQAWBIdyciAlssixdlBMZ985r//xSJJNHoW2e0pOlCsrQ/LWCzCk9nckxft50Tpevtn9TOKvKwSl1PpZ7LeWm4=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4896.namprd04.prod.outlook.com (2603:10b6:805:99::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sun, 12 Jul
 2020 08:42:55 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 08:42:55 +0000
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
Subject: RE: [PATCH v6 2/5] scsi: ufs-qcom: name the dev_ref_clk_ctrl
 registers
Thread-Topic: [PATCH v6 2/5] scsi: ufs-qcom: name the dev_ref_clk_ctrl
 registers
Thread-Index: AQHWVorJmO0LKMZIxEy6qo2UY5jvX6kDo5zQ
Date:   Sun, 12 Jul 2020 08:42:55 +0000
Message-ID: <SN6PR04MB46408276B769C494EDB742DDFC630@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-3-ebiggers@kernel.org>
In-Reply-To: <20200710072013.177481-3-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4252b40a-585d-419a-95f1-08d8263f9285
x-ms-traffictypediagnostic: SN6PR04MB4896:
x-microsoft-antispam-prvs: <SN6PR04MB48967384787842C49430FA86FC630@SN6PR04MB4896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ApQBZ1R5FsH6zweCWvbLCXwCpOrKIi3n/8b0UrlrxyMQRHmMPdhwsXK4iPEaiiP0YE7kvfKU4X/4xBKIQZRSGsfkxAXEwNFqhivFRqH0QMbq765MRYIqt2kCUxUui61iQCuSLij4OCRma4L7dhOgSmgxyZE/Pgos//MhFkndrOtxI0WecbFE+eZzUTNdCYhB9EbJ5sD7lPT2HbP80s81XCmBd7NNt03n5ciK1IGFNJHfufERwDes5KbzukBiDNK39wN8Ij2bB6KpjcRle4QowsY1qm++H3chJfG/Tg7P4m646w0JhADaBlm/k/3bMlbWzO41z42ImdIwJLJNYLu8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(376002)(136003)(39850400004)(66946007)(2906002)(33656002)(316002)(54906003)(110136005)(9686003)(4326008)(55016002)(64756008)(83380400001)(76116006)(71200400001)(52536014)(5660300002)(66556008)(66446008)(8676002)(66476007)(8936002)(86362001)(7696005)(478600001)(6506007)(186003)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Yww5+aXSp3b2eqcfmZQxutGjIV9mKC3oOyE6HNHRGpR28lJtT5XE5WvaYdopycWBUr7ZZsG7O8Lcav2JY45UNO9vhSoJWEgZnurY76XCyuRlUscEqDkADN4YCHjJYjtuP83V2R7Vu0IFouMUZ8zkDi1w5Ov5HWGmLZzKLFz5X6eNaO6NuoRaFzMjOIhVxic9GfbZHvsqalqIwXpQEHoHGE8vR0ZAN4iNRoumZvMCIvy3IxJr0sz1oFVSzxvCOTlpRgIxHuffztdO46ZKQS0Bf5bj1bhabH1EQHscoTk3qDS38HFApHNdeTATyZ1B19KtciMaRbLRqu9CGu1DIXNx2YI67uuN6EbiNo2vZpJ/mamC/SFdOu8O7a5QU2RM1uutArEx/gxRHqJhe+4uGTStxmHg55pWyR6sI26pE25hiZNx7MM7KyNkqznp6GE2IJn6Ts/c5/DF6JvZdz8yTCyDgCtxi82JDKy5A9mP8q97DQ0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4252b40a-585d-419a-95f1-08d8263f9285
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2020 08:42:55.5099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xw6TwrH+N+tcQk53CzCAEoW9PFlYtSpxXnmcleunOk+AomW76M530pbBYPe/ioA/JcoBbzDfWkkWGoIWG6+eng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4896
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



>=20
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> In preparation for adding another optional register range to the
> ufs-qcom driver, name the existing optional register range
> "dev_ref_clk_ctrl_mem".  This allows the driver to refer to the optional
> register ranges by name rather than index.
>=20
> No device-tree files actually have to be updated due to this change,
> since none of them actually declares these registers.
>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  drivers/scsi/ufs/ufs-qcom.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 2e6ddb5cdfc2..bd0b4ed7b37a 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1275,7 +1275,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>                 host->dev_ref_clk_en_mask =3D BIT(26);
>         } else {
>                 /* "dev_ref_clk_ctrl_mem" is optional resource */
> -               res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +               res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM=
,
> +                                                  "dev_ref_clk_ctrl_mem"=
);
>                 if (res) {
>                         host->dev_ref_clk_ctrl_mmio =3D
>                                         devm_ioremap_resource(dev, res);
> --
> 2.27.0

