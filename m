Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E6421C85A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 12 Jul 2020 11:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGLJn7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 12 Jul 2020 05:43:59 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:42923 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727777AbgGLJn6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 12 Jul 2020 05:43:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594547038; x=1626083038;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qaS3SjqH0NcPBt1f5pGoiMmGzTpFMdfjdNFU3aCk41k=;
  b=FUMToKrJ/+yX6KRam6z79Ib96G9oqJudSsW9T518WcowhzQg31Y4YPEm
   LBf3OQ5Qyjmt/66LyyrF5/S6UD9dF7zd0PRpBLOOYJ0ttdjZzcv8ZQghb
   9F1jW08Wt+Wa1Kaq0z3FNzbdudqOdwPrTTcDbJvWbSxGc7JJe86hFuEE7
   YVw5SJRsWmE4IccguGziuG2cZOuaWNqH9y6s3lFvuyhnbHQXiDSlPGLdK
   ICaxPZz/HAt/N5KgqrwJUL3ccUNOcW9eHK+DTjRcEHhfeKGb+Y0DTHmPF
   XXWmy4dmFekUVkdG5AwfNXrQPCBzaoCOSisQLYL/3ITtGTftkT8q6s+ag
   w==;
IronPort-SDR: puvMqBc8O6qSUNlpi3djZNRzeiJl9IkImr/sEFyAz24Mn6ASCxTGwF4Pb4pgJCjEQ5HBf4tqt1
 mt3FcrTNI3nS6kLaVO77Wb6ufamECpfifnirQb+M8PxAZfrumlopmc2TMeSYfbyDx05i9rSliW
 NpVmEGQWDfHJ12WagxHZE1NFqqExomTWIpZqJsfeeUOkTcYMKl/+ypgWzCJKfwwcwAMRzIoeKk
 ynTd6uFt9i2zVyvOxwv2+7Ab3luM3S8xpJx/5cZDV78dj6wEW2+TSS0I7qLNd0OBnL4ETfPsKb
 +zc=
X-IronPort-AV: E=Sophos;i="5.75,343,1589212800"; 
   d="scan'208";a="146551195"
Received: from mail-co1nam04lp2055.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.55])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2020 17:43:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjP2VTBRPxFLt1TJfPHa/+pCRqKvdWDuEJEjjSoxw4VtgRG/QlCKjljozne1TeVBVHbGnQrxZFUMRV/ToBFiM1HrA4evJO2wQhkOEPAQ6AlG3k8iKyQt7whkF4WeiLF6YJXo4224gXfFEsX/kelncz8ku/DPp/KYxpaxdav/JBtLcN0Mm8Nco87kT3p6upe1QLpXmrOaUg0HFH5+Ken2Ql0QZQoDPY8pjg05q7dWwuJqDdFHt71MQR1AJeVOCmA4u228CregomqsjkJVbCvr9pHc/K8wvS8uNpsqcFgacJUnBJsGGBE+qE9FTC69d53WtbctAXHcF+fQNEgtmsZScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0n189HhpIa/PSPvisyJhrUX28sPwI+NrStFGT7bClo=;
 b=WL8vFehjomTUaCpxPIm3IanUF3opEsje51Ie1vp2ZyAyQVnFfV9a7+a7Ro3IBTajk9Vpq4MEnI6fWswOQWMlkZ+IL399IYshlGtg5RGa3KW7FjNuyBNXvMb2YZvQt4He97ktxDkq3gxt4FQvYwWYgaMANh2ktea1QneTS0X8O03FJgXi8d728FqtxQZYf+XVYmhwS/auzKTI1c3dNgqWA7tDEFyMUeq3o8Dd7H0bvibMHrG9Vj1quyGOgEE6xAyqhquZrmA4ogRrQW36lvs4cFFmklCGFPb8YeEQvR4ABsFiIUIrXzrxpEpDS2cIQzNLpirQMPBnqIb7JP1ISkBaaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0n189HhpIa/PSPvisyJhrUX28sPwI+NrStFGT7bClo=;
 b=aI8zx24AjgNuOazBpnAPa084xlEizsPPFPGF9DJKWhEYeJaEOBUWeS/z050RAUinCLRoQUkg3e9FwFQ7IGJglGbaxh63tbLL6Ipu2+VIe6PYK5Xj1bDLwVrWJBX9lUJt6vfbQIcpZN+WhCNLaQ/V996PvHBN0p2xyRJ+pMDg6U0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4190.namprd04.prod.outlook.com (2603:10b6:805:32::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sun, 12 Jul
 2020 09:43:55 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3174.025; Sun, 12 Jul 2020
 09:43:55 +0000
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
Subject: RE: [PATCH v6 5/5] scsi: ufs-qcom: add Inline Crypto Engine support
Thread-Topic: [PATCH v6 5/5] scsi: ufs-qcom: add Inline Crypto Engine support
Thread-Index: AQHWVorJPO8GVUiS7EC14Qzw6kGj46kDtIGA
Date:   Sun, 12 Jul 2020 09:43:55 +0000
Message-ID: <SN6PR04MB46404B733E531C9A35BD55D7FC630@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200710072013.177481-1-ebiggers@kernel.org>
 <20200710072013.177481-6-ebiggers@kernel.org>
In-Reply-To: <20200710072013.177481-6-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 70926cec-26cc-4040-5f80-08d826481804
x-ms-traffictypediagnostic: SN6PR04MB4190:
x-microsoft-antispam-prvs: <SN6PR04MB419007EC27EC220A992512A1FC630@SN6PR04MB4190.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xxaCPUp2d/GhVnOyXAIacdqDscK3zWLGxcAAXweTWImjaoehXGUWeTAUNEKCGSWKaNDxT1A0dG4MPRPyTp7MggDd5OFFJvFHxcP6+TmCP1Y8TVs0Rz2uj+TKcEDL8yTE9GcXU3sQ/BCzeS6wY9Ncxxdx6LHkSERlK6F8RqMp6RAPOQ82x1uuj01JnpKq6V4Dv63FV+l86SH3Z27MIehljSuGnIYzOgqJ76Hz6vUoFFHnIqvjjWtpBhnx5V7RcsXmMT6XuYi9F3T9ZUFaChf3TstPQTnmYLWwQ0gzGkdgmemycXyYeBreu1fhbeyd03P0sMr5PafmchX9tCujGSaSFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39850400004)(396003)(376002)(5660300002)(9686003)(30864003)(2906002)(55016002)(8936002)(6506007)(110136005)(86362001)(8676002)(33656002)(83380400001)(54906003)(66476007)(66446008)(186003)(71200400001)(66946007)(478600001)(7696005)(52536014)(26005)(76116006)(316002)(64756008)(66556008)(4326008)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uGhhBZHCbmEtbRZl/s3Vv+4OmhSg1ECxZWexcaVuHvS8ridRH/QgQI+Dx/A8rzXCIqP+0+SHkUwiUv+TYgJdnzEBtAmL5NzlP3B+2kAGjViAXh/bv0ykM4DJCsocEdsPHlLOaFOxxhW3oEaN09DsVY9WD403P/EuK9TftoFWaY0HlXUEO1eIgcCNSrrwQYDaprnk2d/ivG+r+zK2s6kP+SxznkN83B0iRDhxFVqRKpRxbPSOH9S8tKw4Lk5oTU0UdJKV/2X9Mj/O1xP8TdhBTz9u31qHlT6sM8L4PZuUin8krDbzpMuosTD2tBK+wnKd0a8Yh4Xi/2UO4E19Vr5yXi4BQghfiP4QA3eU3aHN+aLebvoMSL9OzHizMMLlanhvxfvqAhbaDy6H6WiHcNQp03i6UyBtMg17oQ5l7mx3dY2Fwf4GhgNWWyI67GJl6p86SbhHi76i7cTgLbsndJ+SS3/yKPm8/9gPsk0gT8rrOVg=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70926cec-26cc-4040-5f80-08d826481804
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2020 09:43:55.4376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yf9tKgC8leeVNO3aNbcnsG1kLClgFWV0CLbmXNTDmpSPsi3UUL3BMPlxBU4u1M6OjeITN/DeGSAeHg58i2fIIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4190
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>=20
>=20
> From: Eric Biggers <ebiggers@google.com>
>=20
> Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.
>=20
> The standards-compliant parts, such as querying the crypto capabilities
> and enabling crypto for individual UFS requests, are already handled by
> ufshcd-crypto.c, which itself is wired into the blk-crypto framework.
> However, ICE requires vendor-specific init, enable, and resume logic,
> and it requires that keys be programmed and evicted by vendor-specific
> SMC calls.  Make the ufs-qcom driver handle these details.
>=20
> I tested this on Dragonboard 845c, which is a publicly available
> development board that uses the Snapdragon 845 SoC and runs the upstream
> Linux kernel.  This is the same SoC used in the Pixel 3 and Pixel 3 XL
> phones.  This testing included (among other things) verifying that the
> expected ciphertext was produced, both manually using ext4 encryption
> and automatically using a block layer self-test I've written.
>=20
> I've also tested that this driver works nearly as-is on the Snapdragon
> 765 and Snapdragon 865 SoCs.  And others have tested it on Snapdragon
> 850, Snapdragon 855, and Snapdragon 865 (see the Tested-by tags).
>=20
> This is based very loosely on the vendor-provided driver in the kernel
> source code for the Pixel 3, but I've greatly simplified it.  Also, for
> now I've only included support for major version 3 of ICE, since that's
> all I have the hardware to test with the mainline kernel.  Plus it
> appears that version 3 is easier to use than older versions of ICE.
>=20
> For now, only allow using AES-256-XTS.  The hardware also declares
> support for AES-128-XTS, AES-{128,256}-ECB, and AES-{128,256}-CBC
> (BitLocker variant).  But none of these others are really useful, and
> they'd need to be individually tested to be sure they worked properly.
>=20
> This commit also changes the name of the loadable module from "ufs-qcom"
> to "ufs_qcom", as this is necessary to compile it from multiple source
> files (unless we were to rename ufs-qcom.c).
>=20
> Tested-by: Steev Klimaszewski <steev@kali.org> # Lenovo Yoga C630
> Tested-by: Thara Gopinath <thara.gopinath@linaro.org> # db845c, sm8150-
> mtp, sm8250-mtp
> Signed-off-by: Eric Biggers <ebiggers@google.com>
Looks good to me.
Reviewed-by: Avri Altman <avri.altman@wdc.com>


> ---
>  MAINTAINERS                     |   2 +-
>  drivers/scsi/ufs/Kconfig        |   1 +
>  drivers/scsi/ufs/Makefile       |   4 +-
>  drivers/scsi/ufs/ufs-qcom-ice.c | 245 ++++++++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufs-qcom.c     |  12 +-
>  drivers/scsi/ufs/ufs-qcom.h     |  27 ++++
>  6 files changed, 288 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/scsi/ufs/ufs-qcom-ice.c
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 68f21d46614c..aa9c924facc6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2271,7 +2271,7 @@ F:        drivers/pci/controller/dwc/pcie-qcom.c
>  F:     drivers/phy/qualcomm/
>  F:     drivers/power/*/msm*
>  F:     drivers/reset/reset-qcom-*
> -F:     drivers/scsi/ufs/ufs-qcom.*
> +F:     drivers/scsi/ufs/ufs-qcom*
>  F:     drivers/spi/spi-geni-qcom.c
>  F:     drivers/spi/spi-qcom-qspi.c
>  F:     drivers/spi/spi-qup.c
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 46a4542f37eb..f6394999b98c 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -99,6 +99,7 @@ config SCSI_UFS_DWC_TC_PLATFORM
>  config SCSI_UFS_QCOM
>         tristate "QCOM specific hooks to UFS controller platform driver"
>         depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
> +       select QCOM_SCM
>         select RESET_CONTROLLER
>         help
>           This selects the QCOM specific additions to UFSHCD platform dri=
ver.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 9810963bc049..4679af1b564e 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -3,7 +3,9 @@
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-dwc.o tc=
-
> dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
> -obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
> +obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs_qcom.o
> +ufs_qcom-y +=3D ufs-qcom.o
> +ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) +=3D ufs-qcom-ice.o
>  obj-$(CONFIG_SCSI_UFS_EXYNOS) +=3D ufs-exynos.o
>  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
>  ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o
> diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-=
ice.c
> new file mode 100644
> index 000000000000..bbb0ad7590ec
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs-qcom-ice.c
> @@ -0,0 +1,245 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Qualcomm ICE (Inline Crypto Engine) support.
> + *
> + * Copyright (c) 2014-2019, The Linux Foundation. All rights reserved.
> + * Copyright 2019 Google LLC
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/qcom_scm.h>
> +
> +#include "ufshcd-crypto.h"
> +#include "ufs-qcom.h"
> +
> +#define AES_256_XTS_KEY_SIZE                   64
> +
> +/* QCOM ICE registers */
> +
> +#define QCOM_ICE_REG_CONTROL                   0x0000
> +#define QCOM_ICE_REG_RESET                     0x0004
> +#define QCOM_ICE_REG_VERSION                   0x0008
> +#define QCOM_ICE_REG_FUSE_SETTING              0x0010
> +#define QCOM_ICE_REG_PARAMETERS_1              0x0014
> +#define QCOM_ICE_REG_PARAMETERS_2              0x0018
> +#define QCOM_ICE_REG_PARAMETERS_3              0x001C
> +#define QCOM_ICE_REG_PARAMETERS_4              0x0020
> +#define QCOM_ICE_REG_PARAMETERS_5              0x0024
> +
> +/* QCOM ICE v3.X only */
> +#define QCOM_ICE_GENERAL_ERR_STTS              0x0040
> +#define QCOM_ICE_INVALID_CCFG_ERR_STTS         0x0030
> +#define QCOM_ICE_GENERAL_ERR_MASK              0x0044
> +
> +/* QCOM ICE v2.X only */
> +#define QCOM_ICE_REG_NON_SEC_IRQ_STTS          0x0040
> +#define QCOM_ICE_REG_NON_SEC_IRQ_MASK          0x0044
> +
> +#define QCOM_ICE_REG_NON_SEC_IRQ_CLR           0x0048
> +#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME1   0x0050
> +#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME2   0x0054
> +#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME1   0x0058
> +#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME2   0x005C
> +#define QCOM_ICE_REG_STREAM1_BIST_ERROR_VEC    0x0060
> +#define QCOM_ICE_REG_STREAM2_BIST_ERROR_VEC    0x0064
> +#define QCOM_ICE_REG_STREAM1_BIST_FINISH_VEC   0x0068
> +#define QCOM_ICE_REG_STREAM2_BIST_FINISH_VEC   0x006C
> +#define QCOM_ICE_REG_BIST_STATUS               0x0070
> +#define QCOM_ICE_REG_BYPASS_STATUS             0x0074
> +#define QCOM_ICE_REG_ADVANCED_CONTROL          0x1000
> +#define QCOM_ICE_REG_ENDIAN_SWAP               0x1004
> +#define QCOM_ICE_REG_TEST_BUS_CONTROL          0x1010
> +#define QCOM_ICE_REG_TEST_BUS_REG              0x1014
> +
> +/* BIST ("built-in self-test"?) status flags */
> +#define QCOM_ICE_BIST_STATUS_MASK              0xF0000000
> +
> +#define QCOM_ICE_FUSE_SETTING_MASK             0x1
> +#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK    0x2
> +#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK    0x4
> +
> +#define qcom_ice_writel(host, val, reg)        \
> +       writel((val), (host)->ice_mmio + (reg))
> +#define qcom_ice_readl(host, reg)      \
> +       readl((host)->ice_mmio + (reg))
> +
> +static bool qcom_ice_supported(struct ufs_qcom_host *host)
> +{
> +       struct device *dev =3D host->hba->dev;
> +       u32 regval =3D qcom_ice_readl(host, QCOM_ICE_REG_VERSION);
> +       int major =3D regval >> 24;
> +       int minor =3D (regval >> 16) & 0xFF;
> +       int step =3D regval & 0xFFFF;
> +
> +       /* For now this driver only supports ICE version 3. */
> +       if (major !=3D 3) {
> +               dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
> +                        major, minor, step);
> +               return false;
> +       }
> +
> +       dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
> +                major, minor, step);
> +
> +       /* If fuses are blown, ICE might not work in the standard way. */
> +       regval =3D qcom_ice_readl(host, QCOM_ICE_REG_FUSE_SETTING);
> +       if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
> +                     QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
> +                     QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
> +               dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
> +               return false;
> +       }
> +       return true;
> +}
> +
> +int ufs_qcom_ice_init(struct ufs_qcom_host *host)
> +{
> +       struct ufs_hba *hba =3D host->hba;
> +       struct device *dev =3D hba->dev;
> +       struct platform_device *pdev =3D to_platform_device(dev);
> +       struct resource *res;
> +       int err;
> +
> +       if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
> +             MASK_CRYPTO_SUPPORT))
> +               return 0;
> +
> +       res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "ice")=
;
> +       if (!res) {
> +               dev_warn(dev, "ICE registers not found\n");
> +               goto disable;
> +       }
> +
> +       if (!qcom_scm_ice_available()) {
> +               dev_warn(dev, "ICE SCM interface not found\n");
> +               goto disable;
> +       }
> +
> +       host->ice_mmio =3D devm_ioremap_resource(dev, res);
> +       if (IS_ERR(host->ice_mmio)) {
> +               err =3D PTR_ERR(host->ice_mmio);
> +               dev_err(dev, "Failed to map ICE registers; err=3D%d\n", e=
rr);
> +               return err;
> +       }
> +
> +       if (!qcom_ice_supported(host))
> +               goto disable;
> +
> +       return 0;
> +
> +disable:
> +       dev_warn(dev, "Disabling inline encryption support\n");
> +       hba->caps &=3D ~UFSHCD_CAP_CRYPTO;
> +       return 0;
> +}
> +
> +static void qcom_ice_low_power_mode_enable(struct ufs_qcom_host *host)
> +{
> +       u32 regval;
> +
> +       regval =3D qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
> +       /*
> +        * Enable low power mode sequence
> +        * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
> +        */
> +       regval |=3D 0x7000;
> +       qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
> +}
> +
> +static void qcom_ice_optimization_enable(struct ufs_qcom_host *host)
> +{
> +       u32 regval;
> +
> +       /* ICE Optimizations Enable Sequence */
> +       regval =3D qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
> +       regval |=3D 0xD807100;
> +       /* ICE HPG requires delay before writing */
> +       udelay(5);
> +       qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
> +       udelay(5);
> +}
> +
> +int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
> +{
> +       if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
> +               return 0;
> +       qcom_ice_low_power_mode_enable(host);
> +       qcom_ice_optimization_enable(host);
> +       return ufs_qcom_ice_resume(host);
> +}
> +
> +/* Poll until all BIST bits are reset */
> +static int qcom_ice_wait_bist_status(struct ufs_qcom_host *host)
> +{
> +       int count;
> +       u32 reg;
> +
> +       for (count =3D 0; count < 100; count++) {
> +               reg =3D qcom_ice_readl(host, QCOM_ICE_REG_BIST_STATUS);
> +               if (!(reg & QCOM_ICE_BIST_STATUS_MASK))
> +                       break;
> +               udelay(50);
> +       }
> +       if (reg)
> +               return -ETIMEDOUT;
> +       return 0;
> +}
> +
> +int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
> +{
> +       int err;
> +
> +       if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
> +               return 0;
> +
> +       err =3D qcom_ice_wait_bist_status(host);
> +       if (err) {
> +               dev_err(host->hba->dev, "BIST status error (%d)\n", err);
> +               return err;
> +       }
> +       return 0;
> +}
> +
> +/*
> + * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE requ=
ires
> + * vendor-specific SCM calls for this; it doesn't support the standard w=
ay.
> + */
> +int ufs_qcom_ice_program_key(struct ufs_hba *hba,
> +                            const union ufs_crypto_cfg_entry *cfg, int s=
lot)
> +{
> +       union ufs_crypto_cap_entry cap;
> +       union {
> +               u8 bytes[AES_256_XTS_KEY_SIZE];
> +               u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
> +       } key;
> +       int i;
> +       int err;
> +
> +       if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
> +               return qcom_scm_ice_invalidate_key(slot);
> +
> +       /* Only AES-256-XTS has been tested so far. */
> +       cap =3D hba->crypto_cap_array[cfg->crypto_cap_idx];
> +       if (cap.algorithm_id !=3D UFS_CRYPTO_ALG_AES_XTS ||
> +           cap.key_size !=3D UFS_CRYPTO_KEY_SIZE_256) {
> +               dev_err_ratelimited(hba->dev,
> +                                   "Unhandled crypto capability; algorit=
hm_id=3D%d,
> key_size=3D%d\n",
> +                                   cap.algorithm_id, cap.key_size);
> +               return -EINVAL;
> +       }
> +
> +       memcpy(key.bytes, cfg->crypto_key, AES_256_XTS_KEY_SIZE);
> +
> +       /*
> +        * The SCM call byte-swaps the 32-bit words of the key.  So we ha=
ve to
> +        * do the same, in order for the final key be correct.
> +        */
> +       for (i =3D 0; i < ARRAY_SIZE(key.words); i++)
> +               __cpu_to_be32s(&key.words[i]);
> +
> +       err =3D qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZ=
E,
> +                                  QCOM_SCM_ICE_CIPHER_AES_256_XTS,
> +                                  cfg->data_unit_size);
> +       memzero_explicit(&key, sizeof(key));
> +       return err;
> +}
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index bd0b4ed7b37a..139c3ae05e95 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -365,7 +365,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba
> *hba,
>                 /* check if UFS PHY moved from DISABLED to HIBERN8 */
>                 err =3D ufs_qcom_check_hibern8(hba);
>                 ufs_qcom_enable_hw_clk_gating(hba);
> -
> +               ufs_qcom_ice_enable(host);
>                 break;
>         default:
>                 dev_err(hba->dev, "%s: invalid status %d\n", __func__, st=
atus);
> @@ -613,6 +613,10 @@ static int ufs_qcom_resume(struct ufs_hba *hba,
> enum ufs_pm_op pm_op)
>                         return err;
>         }
>=20
> +       err =3D ufs_qcom_ice_resume(host);
> +       if (err)
> +               return err;
> +
>         hba->is_sys_suspended =3D false;
>         return 0;
>  }
> @@ -1071,6 +1075,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
>         hba->caps |=3D UFSHCD_CAP_CLK_SCALING;
>         hba->caps |=3D UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
>         hba->caps |=3D UFSHCD_CAP_WB_EN;
> +       hba->caps |=3D UFSHCD_CAP_CRYPTO;
>=20
>         if (host->hw_ver.major >=3D 0x2) {
>                 host->caps =3D UFS_QCOM_CAP_QUNIPRO |
> @@ -1298,6 +1303,10 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>         ufs_qcom_set_caps(hba);
>         ufs_qcom_advertise_quirks(hba);
>=20
> +       err =3D ufs_qcom_ice_init(host);
> +       if (err)
> +               goto out_variant_clear;
> +
>         ufs_qcom_set_bus_vote(hba, true);
>         ufs_qcom_setup_clocks(hba, true, POST_CHANGE);
>=20
> @@ -1736,6 +1745,7 @@ static const struct ufs_hba_variant_ops
> ufs_hba_qcom_vops =3D {
>         .dbg_register_dump      =3D ufs_qcom_dump_dbg_regs,
>         .device_reset           =3D ufs_qcom_device_reset,
>         .config_scaling_param =3D ufs_qcom_config_scaling_param,
> +       .program_key            =3D ufs_qcom_ice_program_key,
>  };
>=20
>  /**
> diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
> index 2d95e7cc7187..97247d17e258 100644
> --- a/drivers/scsi/ufs/ufs-qcom.h
> +++ b/drivers/scsi/ufs/ufs-qcom.h
> @@ -227,6 +227,9 @@ struct ufs_qcom_host {
>         void __iomem *dev_ref_clk_ctrl_mmio;
>         bool is_dev_ref_clk_enabled;
>         struct ufs_hw_version hw_ver;
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +       void __iomem *ice_mmio;
> +#endif
>=20
>         u32 dev_ref_clk_en_mask;
>=20
> @@ -264,4 +267,28 @@ static inline bool ufs_qcom_cap_qunipro(struct
> ufs_qcom_host *host)
>                 return false;
>  }
>=20
> +/* ufs-qcom-ice.c */
> +
> +#ifdef CONFIG_SCSI_UFS_CRYPTO
> +int ufs_qcom_ice_init(struct ufs_qcom_host *host);
> +int ufs_qcom_ice_enable(struct ufs_qcom_host *host);
> +int ufs_qcom_ice_resume(struct ufs_qcom_host *host);
> +int ufs_qcom_ice_program_key(struct ufs_hba *hba,
> +                            const union ufs_crypto_cfg_entry *cfg, int s=
lot);
> +#else
> +static inline int ufs_qcom_ice_init(struct ufs_qcom_host *host)
> +{
> +       return 0;
> +}
> +static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host)
> +{
> +       return 0;
> +}
> +static inline int ufs_qcom_ice_resume(struct ufs_qcom_host *host)
> +{
> +       return 0;
> +}
> +#define ufs_qcom_ice_program_key NULL
> +#endif /* !CONFIG_SCSI_UFS_CRYPTO */
> +
>  #endif /* UFS_QCOM_H_ */
> --
> 2.27.0

