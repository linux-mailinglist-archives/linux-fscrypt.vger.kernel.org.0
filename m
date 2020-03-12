Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4D718387A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 19:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCLSVJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 14:21:09 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:30233 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgCLSVJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 14:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1584037268; x=1615573268;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=ah0kXTEPQLMb1Sh+Tdd2DLZV8GFDaibLBkrRCHTa4+8=;
  b=AXgP9PxB+bd3n4RVGG4UWQTgCl0X/s8v+s4zsM6J/Y1NonUgBZ9Zakwe
   0O5KMt5Q768NgwJpkuC9B5UN+xnfMxOcnvLQrxnQzu5TPXn8vsyAXnqGq
   h64bhh1t7LW6GLgwwSyOzmyDvHgmkUx3rqsbU01dK80f2D3bYw6rmQoWk
   k=;
Subject: RE: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine support
Thread-Topic: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine support
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 12 Mar 2020 11:21:08 -0700
Received: from nasanexm01b.na.qualcomm.com ([10.85.0.82])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/AES256-SHA; 12 Mar 2020 11:21:07 -0700
Received: from APSANEXR01F.ap.qualcomm.com (10.85.0.39) by
 NASANEXM01B.na.qualcomm.com (10.85.0.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Mar 2020 11:21:06 -0700
Received: from nasanexm03e.na.qualcomm.com (10.85.0.48) by
 APSANEXR01F.ap.qualcomm.com (10.85.0.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Mar 2020 11:21:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (199.106.107.6)
 by nasanexm03e.na.qualcomm.com (10.85.0.48) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Thu, 12 Mar 2020 11:21:03 -0700
Received: from BY5PR02MB6577.namprd02.prod.outlook.com (2603:10b6:a03:20d::13)
 by BY5PR02MB6755.namprd02.prod.outlook.com (2603:10b6:a03:205::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Thu, 12 Mar
 2020 18:21:02 +0000
Received: from BY5PR02MB6577.namprd02.prod.outlook.com
 ([fe80::5d38:9a6b:aab1:f9c9]) by BY5PR02MB6577.namprd02.prod.outlook.com
 ([fe80::5d38:9a6b:aab1:f9c9%5]) with mapi id 15.20.2814.007; Thu, 12 Mar 2020
 18:21:02 +0000
From:   Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>
Thread-Index: AQHV+JGq9xTqlTM6802wEvtiviGrNqhFQjSA
Date:   Thu, 12 Mar 2020 18:21:02 +0000
Message-ID: <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
References: <20200312171259.151442-1-ebiggers@kernel.org>
 <20200312171259.151442-5-ebiggers@kernel.org>
In-Reply-To: <20200312171259.151442-5-ebiggers@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bmuthuku@qti.qualcomm.com; 
x-originating-ip: [199.106.103.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d33d932-2833-48eb-aa9f-08d7c6b21ef2
x-ms-traffictypediagnostic: BY5PR02MB6755:
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB675520DFE26E43CD2F13BC8CFFFD0@BY5PR02MB6755.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0340850FCD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(346002)(366004)(199004)(33656002)(30864003)(7696005)(4326008)(66476007)(8936002)(2906002)(53546011)(110136005)(6506007)(316002)(54906003)(71200400001)(52536014)(5660300002)(86362001)(26005)(7416002)(186003)(8676002)(55016002)(81166006)(81156014)(9686003)(478600001)(66556008)(66946007)(66446008)(76116006)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR02MB6755;H:BY5PR02MB6577.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jT69u3ucIPYTIsg5l4k/25gH7+1cNXL3i15OHDlKKdsCawcYdDB+EfssEWnRp8EFz5GOlVJUOlPvhrHA2rTKPgX4Q7VqXSkavJt11T97hRl6hrvkIBYgEpAeze/+k1AtMfQ86BN+fmkp86gsfBG6qPM8HBb7ayZlMc6MTJjs+w9bdr0EY4U6ZhLatpAOVeIn78cfNxOGHmnuKWalUp+N4VM90H93wpewSZ9DXo4Tv1lXfjMAHtiMGYR7U4M7FtUhZnbBHOM82s8nxa5H6Gi/gRWx5VTyDtRuLC3s2it+opaIhXOiCzEmYrNisy+1UL2DVmW6IseSYuCETsNs7SWELfo8UmR/8fnnRGTHUdDVNedDdoHz0tSz4WbgDfBM2DqRd/Zj/YXwdslfmjRDLvoakeMePkpY8PdF92Bhr6t411mhczApO2YCP2GeUOWak9fo
x-ms-exchange-antispam-messagedata: gbk2KotR0jBnEUipYtfD6dG/XygkfTV2RS+hzLcYLgh51Fi/glxT6eQ6F69IT+RdEp13Mu1xuGM20bz3iNxdFge4MoPK+D+DbNGRNJJy/sO75UNW56V/djcx6w4Lk/c+FrzwmbOqo0mVQbE0WYWMwQ==
x-ms-exchange-transport-forked: True
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W4JxNGpUSpjQ7rfpKlD1BkTvVjuhSlDhClREDOaAmQn2C6ha9eHeqjxd9Jsq7qV1S6LXsjPM83rrtzW/ayAAiMFdWva5wCEQqe/9wAy2yDKbqaryiiKG6KmewADSH6KjXPQjnn2SepbF/4WspY4zDu0W35zj+nRu/xw6OBsgzyYykavXqfQs5eNVpjcYSXy1MrOyRnBEYD52eCvpWir2YYVWC7FoVKvsi1Pev0OXtw/L06mG4TkX2tOPCuv66Y9cs0Rs80/paYeaZ23N4CcRoeu/2dSeNgF3IXdWK5k9Lg2DPmkdxJNjw/INE0JwD5yGB1NH3+7n9pVJC+RhiPiX8w==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVUqraJWfhIlSMsTxPikATgF6CIPkAV3gjN9ETc2f+A=;
 b=XgwTmSdl9Fqdi/tLecx5pHmZDg1gjR+FAgJYJlbLvN0fgJ8xKvgfVpW+0EP87G1pZEkxU//bBAzMeuwML6FMYthTJbmlrkzdcQ6OlUUl5MqtFU+TbijNTjkTnoqWqG8OdWcozR7sFgz3CSl8Sii5qMC2/db200JSLA0iyX2UknafPZdS3nDYou2AmOr5JRTcZkmQUzgCJnBbrYsIcKkBetj1vsVy3NufvvYPXWDmdaiD1bY2LJOam7tqR6AEQYSuLo8C7lnZckA3kN2OxN+JJDqGa67mQNMW6lJLsN+u9dENzOZ7wqof5qWtgUE2I2VZ6KkuPQgbUu96UuI2mfjDHA==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=qualcomm.onmicrosoft.com; s=selector1-qualcomm-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVUqraJWfhIlSMsTxPikATgF6CIPkAV3gjN9ETc2f+A=;
 b=CSoKOhq/qu2zpdmI83w7sQhQWK+JlM6E7r84OmiXSbJTMsZvzz0oK1+pIMIlBfy4bgUmCIvhVcnm79sBbw7vZCwPN1noZyiA5UZ/Z2nZQBBITK8yXDbux18/WkM9OwGLQlhIm1kZ6x7I34iDBbyqHULSWhhl6tn29yE0TLvyahU=
x-ms-exchange-crosstenant-network-message-id: 7d33d932-2833-48eb-aa9f-08d7c6b21ef2
x-ms-exchange-crosstenant-originalarrivaltime: 12 Mar 2020 18:21:02.0598 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: QrCDbbZU07+wymm5NymS0CuU2wcxewqH/9L0b3s2DWux/IhtggENC14Op9huLTaUkKkif/E93T8a8d0QNCyEY8iqP/oWdb6ugUTmoVcQeyk=
x-ms-exchange-transport-crosstenantheadersstamped: BY5PR02MB6755
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

I am confused on why you are trying to re-implement functions already prese=
nt within the crypto_vops. Is there a reason why the ICE driver cannot regi=
ster for KSM with its own function for keyslot_program and keyslot_evict an=
d register for crypto_vops with its own functions for 'init/enable/disable/=
suspend/resume/debug'. Given that the ufs-crypto has the interface to do th=
is why do we have to re-implement the same functionality with another set o=
f functions. In addition in the future if for performance reasons (with per=
-file keys) we have to use passthrough KSM and use prepare/complete_lrbp_cr=
ypto that can easily be added as well.

IMO the crypto_vops is a clean way for vendors to override the default func=
tionality rather than using direct function calls from within the UFS drive=
r and this can easily be extended for eMMC.

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>
Sent: Thursday, March 12, 2020 10:13 AM
To: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org
Cc: linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; Alim Akhtar=
 <alim.akhtar@samsung.com>; Andy Gross <agross@kernel.org>; Avri Altman <av=
ri.altman@wdc.com>; Barani Muthukumaran <bmuthuku@qti.qualcomm.com>; bjorn.=
andersson@linaro.org; Can Guo <cang@codeaurora.org>; Elliot Berman <eberman=
@codeaurora.org>; Jaegeuk Kim <jaegeuk@kernel.org>; John Stultz <john.stult=
z@linaro.org>; Satya Tangirala <satyat@google.com>
Subject: [EXT] [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine =
support

From: Eric Biggers <ebiggers@google.com>

Add support for Qualcomm Inline Crypto Engine (ICE) to ufs-qcom.

The standards-compliant parts, such as querying the crypto capabilities and=
 enabling crypto for individual UFS requests, are already handled by ufshcd=
-crypto.c, which itself is wired into the blk-crypto framework.
However, ICE requires vendor-specific init, enable, and resume logic, and i=
t requires that keys be programmed and evicted by vendor-specific SMC calls=
.  Make the ufs-qcom driver handle these details.

I tested this on Dragonboard 845c, which is a publicly available developmen=
t board that uses the Snapdragon 845 SoC and runs the upstream Linux kernel=
.  This is the same SoC used in the Pixel 3 and Pixel 3 XL phones.  This te=
sting included (among other things) verifying that the expected ciphertext =
was produced, both manually using ext4 encryption and automatically using a=
 block layer self-test I've written.

This driver also works nearly as-is on Snapdragon 765 and Snapdragon 865, w=
hich are very recent SoCs, having just been announced in Dec 2019 (though t=
hese newer SoCs currently lack upstream kernel support).

This is based very loosely on the vendor-provided driver in the kernel sour=
ce code for the Pixel 3, but I've greatly simplified it.  Also, for now I'v=
e only included support for major version 3 of ICE, since that's all I have=
 the hardware to test with the mainline kernel.  Plus it appears that versi=
on 3 is easier to use than older versions of ICE.

For now, only allow using AES-256-XTS.  The hardware also declares support =
for AES-128-XTS, AES-{128,256}-ECB, and AES-{128,256}-CBC (BitLocker varian=
t).  But none of these others are really useful, and they'd need to be indi=
vidually tested to be sure they worked properly.

This commit also changes the name of the loadable module from "ufs-qcom"
to "ufs_qcom", as this is necessary to compile it from multiple source file=
s (unless we were to rename ufs-qcom.c).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 MAINTAINERS                     |   2 +-
 drivers/scsi/ufs/Kconfig        |   1 +
 drivers/scsi/ufs/Makefile       |   4 +-
 drivers/scsi/ufs/ufs-qcom-ice.c | 244 ++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.c     |  12 +-
 drivers/scsi/ufs/ufs-qcom.h     |  27 ++++
 6 files changed, 287 insertions(+), 3 deletions(-)  create mode 100644 dri=
vers/scsi/ufs/ufs-qcom-ice.c

diff --git a/MAINTAINERS b/MAINTAINERS
index a0d86490c2c62..d0df7738fcb88 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2202,7 +2202,7 @@ F:drivers/pci/controller/dwc/pcie-qcom.c
 F:drivers/phy/qualcomm/
 F:drivers/power/*/msm*
 F:drivers/reset/reset-qcom-*
-F:drivers/scsi/ufs/ufs-qcom.*
+F:drivers/scsi/ufs/ufs-qcom*
 F:drivers/spi/spi-qup.c
 F:drivers/spi/spi-geni-qcom.c
 F:drivers/spi/spi-qcom-qspi.c
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig index c69f=
1b49167b0..7d1260988ab2b 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,6 +99,7 @@ config SCSI_UFS_DWC_TC_PLATFORM  config SCSI_UFS_QCOM
 tristate "QCOM specific hooks to UFS controller platform driver"
 depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
+select QCOM_SCM
 select RESET_CONTROLLER
 help
   This selects the QCOM specific additions to UFSHCD platform driver.
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile index 19=
7e178f44bce..13fda1b697b2a 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -3,7 +3,9 @@
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-dwc.o tc-d=
wc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o ufshcd-dw=
c.o tc-dwc-g210.o
 obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
-obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
+obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs_qcom.o ufs_qcom-y +=3D ufs-qcom.o
+ufs_qcom-$(CONFIG_SCSI_UFS_CRYPTO) +=3D ufs-qcom-ice.o
 obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
 ufshcd-core-y+=3D ufshcd.o ufs-sysfs.o
 ufshcd-core-$(CONFIG_SCSI_UFS_BSG)+=3D ufs_bsg.o
diff --git a/drivers/scsi/ufs/ufs-qcom-ice.c b/drivers/scsi/ufs/ufs-qcom-ic=
e.c new file mode 100644 index 0000000000000..b2c592003d1a2
--- /dev/null
+++ b/drivers/scsi/ufs/ufs-qcom-ice.c
@@ -0,0 +1,244 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Qualcomm ICE (Inline Crypto Engine) support.
+ *
+ * Copyright (c) 2014-2019, The Linux Foundation. All rights reserved.
+ * Copyright (c) 2019 Google LLC
+ */
+
+#include <linux/platform_device.h>
+#include <linux/qcom_scm.h>
+
+#include "ufshcd-crypto.h"
+#include "ufs-qcom.h"
+
+#define AES_256_XTS_KEY_SIZE64
+
+/* QCOM ICE registers */
+
+#define QCOM_ICE_REG_CONTROL0x0000
+#define QCOM_ICE_REG_RESET0x0004
+#define QCOM_ICE_REG_VERSION0x0008
+#define QCOM_ICE_REG_FUSE_SETTING0x0010
+#define QCOM_ICE_REG_PARAMETERS_10x0014
+#define QCOM_ICE_REG_PARAMETERS_20x0018
+#define QCOM_ICE_REG_PARAMETERS_30x001C
+#define QCOM_ICE_REG_PARAMETERS_40x0020
+#define QCOM_ICE_REG_PARAMETERS_50x0024
+
+/* QCOM ICE v3.X only */
+#define QCOM_ICE_GENERAL_ERR_STTS0x0040
+#define QCOM_ICE_INVALID_CCFG_ERR_STTS0x0030
+#define QCOM_ICE_GENERAL_ERR_MASK0x0044
+
+/* QCOM ICE v2.X only */
+#define QCOM_ICE_REG_NON_SEC_IRQ_STTS0x0040
+#define QCOM_ICE_REG_NON_SEC_IRQ_MASK0x0044
+
+#define QCOM_ICE_REG_NON_SEC_IRQ_CLR0x0048
+#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME10x0050
+#define QCOM_ICE_REG_STREAM1_ERROR_SYNDROME20x0054
+#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME10x0058
+#define QCOM_ICE_REG_STREAM2_ERROR_SYNDROME20x005C
+#define QCOM_ICE_REG_STREAM1_BIST_ERROR_VEC0x0060
+#define QCOM_ICE_REG_STREAM2_BIST_ERROR_VEC0x0064
+#define QCOM_ICE_REG_STREAM1_BIST_FINISH_VEC0x0068
+#define QCOM_ICE_REG_STREAM2_BIST_FINISH_VEC0x006C
+#define QCOM_ICE_REG_BIST_STATUS0x0070
+#define QCOM_ICE_REG_BYPASS_STATUS0x0074
+#define QCOM_ICE_REG_ADVANCED_CONTROL0x1000
+#define QCOM_ICE_REG_ENDIAN_SWAP0x1004
+#define QCOM_ICE_REG_TEST_BUS_CONTROL0x1010
+#define QCOM_ICE_REG_TEST_BUS_REG0x1014
+
+/* BIST ("built-in self-test"?) status flags */
+#define QCOM_ICE_BIST_STATUS_MASK0xF0000000
+
+#define QCOM_ICE_FUSE_SETTING_MASK0x1
+#define QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK0x2
+#define QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK0x4
+
+#define qcom_ice_writel(host, val, reg)\
+writel((val), (host)->ice_mmio + (reg))
+#define qcom_ice_readl(host, reg)\
+readl((host)->ice_mmio + (reg))
+
+static bool qcom_ice_supported(struct ufs_qcom_host *host) {
+struct device *dev =3D host->hba->dev;
+u32 regval =3D qcom_ice_readl(host, QCOM_ICE_REG_VERSION);
+int major =3D regval >> 24;
+int minor =3D (regval >> 16) & 0xFF;
+int step =3D regval & 0xFFFF;
+
+/* For now this driver only supports ICE version 3. */
+if (major !=3D 3) {
+dev_warn(dev, "Unsupported ICE version: v%d.%d.%d\n",
+ major, minor, step);
+return false;
+}
+
+dev_info(dev, "Found QC Inline Crypto Engine (ICE) v%d.%d.%d\n",
+ major, minor, step);
+
+/* If fuses are blown, ICE might not work in the standard way. */
+regval =3D qcom_ice_readl(host, QCOM_ICE_REG_FUSE_SETTING);
+if (regval & (QCOM_ICE_FUSE_SETTING_MASK |
+      QCOM_ICE_FORCE_HW_KEY0_SETTING_MASK |
+      QCOM_ICE_FORCE_HW_KEY1_SETTING_MASK)) {
+dev_warn(dev, "Fuses are blown; ICE is unusable!\n");
+return false;
+}
+return true;
+}
+
+int ufs_qcom_ice_init(struct ufs_qcom_host *host) {
+struct ufs_hba *hba =3D host->hba;
+struct device *dev =3D hba->dev;
+struct platform_device *pdev =3D to_platform_device(dev);
+struct resource *res;
+int err;
+
+if (!(ufshcd_readl(hba, REG_CONTROLLER_CAPABILITIES) &
+      MASK_CRYPTO_SUPPORT))
+return 0;
+
+res =3D platform_get_resource(pdev, IORESOURCE_MEM, 2);
+if (!res) {
+dev_warn(dev, "ICE registers not found\n");
+goto disable;
+}
+
+if (!qcom_scm_ice_available()) {
+dev_warn(dev, "ICE SCM interface not found\n");
+goto disable;
+}
+
+host->ice_mmio =3D devm_ioremap_resource(dev, res);
+if (IS_ERR(host->ice_mmio)) {
+dev_err(dev, "Failed to map ICE registers; err=3D%d\n", err);
+return err;
+}
+
+if (!qcom_ice_supported(host))
+goto disable;
+
+return 0;
+
+disable:
+dev_warn(dev, "Disabling inline encryption support\n");
+hba->caps &=3D ~UFSHCD_CAP_CRYPTO;
+return 0;
+}
+
+static void qcom_ice_low_power_mode_enable(struct ufs_qcom_host *host)
+{
+u32 regval;
+
+regval =3D qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
+/*
+ * Enable low power mode sequence
+ * [0]-0, [1]-0, [2]-0, [3]-E, [4]-0, [5]-0, [6]-0, [7]-0
+ */
+regval |=3D 0x7000;
+qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL); }
+
+static void qcom_ice_optimization_enable(struct ufs_qcom_host *host) {
+u32 regval;
+
+/* ICE Optimizations Enable Sequence */
+regval =3D qcom_ice_readl(host, QCOM_ICE_REG_ADVANCED_CONTROL);
+regval |=3D 0xD807100;
+/* ICE HPG requires delay before writing */
+udelay(5);
+qcom_ice_writel(host, regval, QCOM_ICE_REG_ADVANCED_CONTROL);
+udelay(5);
+}
+
+int ufs_qcom_ice_enable(struct ufs_qcom_host *host) {
+if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
+return 0;
+qcom_ice_low_power_mode_enable(host);
+qcom_ice_optimization_enable(host);
+return ufs_qcom_ice_resume(host);
+}
+
+/* Poll until all BIST bits are reset */ static int
+qcom_ice_wait_bist_status(struct ufs_qcom_host *host) {
+int count;
+u32 reg;
+
+for (count =3D 0; count < 100; count++) {
+reg =3D qcom_ice_readl(host, QCOM_ICE_REG_BIST_STATUS);
+if (!(reg & QCOM_ICE_BIST_STATUS_MASK))
+break;
+udelay(50);
+}
+if (reg)
+return -ETIMEDOUT;
+return 0;
+}
+
+int ufs_qcom_ice_resume(struct ufs_qcom_host *host) {
+int err;
+
+if (!(host->hba->caps & UFSHCD_CAP_CRYPTO))
+return 0;
+
+err =3D qcom_ice_wait_bist_status(host);
+if (err) {
+dev_err(host->hba->dev, "BIST status error (%d)\n", err);
+return err;
+}
+return 0;
+}
+
+/*
+ * Program a key into a QC ICE keyslot, or evict a keyslot.  QC ICE
+requires
+ * vendor-specific SCM calls for this; it doesn't support the standard way=
.
+ */
+int ufs_qcom_ice_program_key(struct ufs_hba *hba,
+     const union ufs_crypto_cfg_entry *cfg, int slot) {
+union ufs_crypto_cap_entry cap;
+union {
+u8 bytes[AES_256_XTS_KEY_SIZE];
+u32 words[AES_256_XTS_KEY_SIZE / sizeof(u32)];
+} key;
+int i;
+int err;
+
+if (!(cfg->config_enable & UFS_CRYPTO_CONFIGURATION_ENABLE))
+return qcom_scm_ice_invalidate_key(slot);
+
+/* Only AES-256-XTS has been tested so far. */
+cap =3D hba->crypto_cap_array[cfg->crypto_cap_idx];
+if (cap.algorithm_id !=3D UFS_CRYPTO_ALG_AES_XTS ||
+    cap.key_size !=3D UFS_CRYPTO_KEY_SIZE_256) {
+dev_err_ratelimited(hba->dev,
+    "Unhandled crypto capability; algorithm_id=3D%d, key_size=3D%d\n",
+    cap.algorithm_id, cap.key_size);
+return -EINVAL;
+}
+
+memcpy(key.bytes, cfg->crypto_key, AES_256_XTS_KEY_SIZE);
+
+/*
+ * ICE (or maybe the SCM call?) byte-swaps the 32-bit words of the key.
+ * So we have to do the same, in order for the final key be correct.
+ */
+for (i =3D 0; i < ARRAY_SIZE(key.words); i++)
+__cpu_to_be32s(&key.words[i]);
+
+err =3D qcom_scm_ice_set_key(slot, key.bytes, AES_256_XTS_KEY_SIZE,
+   QCOM_SCM_ICE_CIPHER_AES_256_XTS,
+   cfg->data_unit_size);
+memzero_explicit(&key, sizeof(key));
+return err;
+}
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c inde=
x c69c29a1ceb90..5b3fbbbb7c0af 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -365,7 +365,7 @@ static int ufs_qcom_hce_enable_notify(struct ufs_hba *h=
ba,
 /* check if UFS PHY moved from DISABLED to HIBERN8 */
 err =3D ufs_qcom_check_hibern8(hba);
 ufs_qcom_enable_hw_clk_gating(hba);
-
+ufs_qcom_ice_enable(host);
 break;
 default:
 dev_err(hba->dev, "%s: invalid status %d\n", __func__, status); @@ -616,6 =
+616,10 @@ static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op p=
m_op)
 return err;
 }

+err =3D ufs_qcom_ice_resume(host);
+if (err)
+return err;
+
 hba->is_sys_suspended =3D false;
 return 0;
 }
@@ -1011,6 +1015,7 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
 hba->caps |=3D UFSHCD_CAP_CLK_GATING | UFSHCD_CAP_HIBERN8_WITH_CLK_GATING;
 hba->caps |=3D UFSHCD_CAP_CLK_SCALING;
 hba->caps |=3D UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
+hba->caps |=3D UFSHCD_CAP_CRYPTO;

 if (host->hw_ver.major >=3D 0x2) {
 host->caps =3D UFS_QCOM_CAP_QUNIPRO |
@@ -1238,6 +1243,10 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 ufs_qcom_set_caps(hba);
 ufs_qcom_advertise_quirks(hba);

+err =3D ufs_qcom_ice_init(host);
+if (err)
+goto out_variant_clear;
+
 ufs_qcom_setup_clocks(hba, true, POST_CHANGE);

 if (hba->dev->id < MAX_UFS_QCOM_HOSTS) @@ -1651,6 +1660,7 @@ static const =
struct ufs_hba_variant_ops ufs_hba_qcom_vops =3D {
 .resume=3D ufs_qcom_resume,
 .dbg_register_dump=3D ufs_qcom_dump_dbg_regs,
 .device_reset=3D ufs_qcom_device_reset,
+.program_key=3D ufs_qcom_ice_program_key,
 };

 /**
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h inde=
x 2d95e7cc71874..97247d17e258a 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -227,6 +227,9 @@ struct ufs_qcom_host {
 void __iomem *dev_ref_clk_ctrl_mmio;
 bool is_dev_ref_clk_enabled;
 struct ufs_hw_version hw_ver;
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+void __iomem *ice_mmio;
+#endif

 u32 dev_ref_clk_en_mask;

@@ -264,4 +267,28 @@ static inline bool ufs_qcom_cap_qunipro(struct ufs_qco=
m_host *host)
 return false;
 }

+/* ufs-qcom-ice.c */
+
+#ifdef CONFIG_SCSI_UFS_CRYPTO
+int ufs_qcom_ice_init(struct ufs_qcom_host *host); int
+ufs_qcom_ice_enable(struct ufs_qcom_host *host); int
+ufs_qcom_ice_resume(struct ufs_qcom_host *host); int
+ufs_qcom_ice_program_key(struct ufs_hba *hba,
+     const union ufs_crypto_cfg_entry *cfg, int slot); #else static
+inline int ufs_qcom_ice_init(struct ufs_qcom_host *host) {
+return 0;
+}
+static inline int ufs_qcom_ice_enable(struct ufs_qcom_host *host) {
+return 0;
+}
+static inline int ufs_qcom_ice_resume(struct ufs_qcom_host *host) {
+return 0;
+}
+#define ufs_qcom_ice_program_key NULL
+#endif /* !CONFIG_SCSI_UFS_CRYPTO */
+
 #endif /* UFS_QCOM_H_ */
--
2.25.1

