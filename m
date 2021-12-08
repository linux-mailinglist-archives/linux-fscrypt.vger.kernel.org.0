Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9046C881
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Dec 2021 01:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242754AbhLHAMi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Dec 2021 19:12:38 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.140.77]:54427 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhLHAMh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Dec 2021 19:12:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qccesdkim1; t=1638922146; x=1639526946;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ata6/kWazvu+vpj/MOB1EuMe78UmT2bzE9cSus2oy4Q=;
  b=w9vBOMb23P0zD8RyqG4Sbdbq2GMXyhinGxv17/mIDfEKN8h4uggZq/YB
   nlwzZSh1u40tPzaFYwd9lXowys2JmmaXbjgOh9TlarGOdQfeNAlhEbRKM
   RDnBe2KBCQbv0NFTdTsOv5leCFVwqrQ2Bokd6cgSNuY6fQWivyKFfBtQO
   U=;
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 00:09:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYx79wkEXrCbDCgAg7mQeoWQvD6QO4pxdrOFz/ZGAdGCBWt64+IAKmpwAvudKTdLylP0uqcL69467jY9p3V1Q44DixG/I/AGrcjyy0KKrBRXIGp8wGxdNBDgU5bBoGVZQJCtQR1SzelGNCVLD3qtdJLWJGUAN7I/b4zr1soXPGChFaulEQLKVhfgGB/0VxWmk3ZwvVF30d1FjOiyyK9DYB8xV0IIOy9GJ2Z2b0BRjittNkTRlpu7Igng+d8X42sNSg5ZMzWXXVKB/+PO3qPuT70eGyP/7nFSGuYId8emyIg+c39LTe9cl83zgS4ns4AsgnL0nWzSmjUNPBFXktCBdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ata6/kWazvu+vpj/MOB1EuMe78UmT2bzE9cSus2oy4Q=;
 b=V3Z7bXS3lyOavNe+l4bccxZLoiP8gFvP85hCXO+8EmnX4giLXMEiYBCnEs8duVqWqohzX20U34OQYXKYuElB9wnw7/coTkeVoEVouFY7WlWV5HwK6FCEfvSAf5iq7jQH+LJKB+aOWkFUbIsdL18WcugPHkeJLOmABUwqucY0bkdXrEJAESKaF1JGemhnnj2PPvTczWQxEv7xQZ3VBV4mZ0xTrxWpeFR83iewkWkyrYEH3VEGstB0y6egRrZGHqtmEX4lvIr7559LJQSnEt7DnEDn/SddorQcaxlaasMnT+ZKk7xW9HgrtpClWvdGUI3EGjf6u9tzbkh0+NOYnssrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by SJ0PR02MB7853.namprd02.prod.outlook.com (2603:10b6:a03:32e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Wed, 8 Dec
 2021 00:09:03 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::7028:1b1c:7c3c:d15e]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::7028:1b1c:7c3c:d15e%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 00:09:03 +0000
From:   Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "thara.gopinath@linaro.org" <thara.gopinath@linaro.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
Subject: RE: [PATCH 0/4] Adds wrapped key support for inline storage
 encryption
Thread-Topic: [PATCH 0/4] Adds wrapped key support for inline storage
 encryption
Thread-Index: AQHX0Qk30OEZMGexr0eC03luU1yS+qvz+lEAgDPzA3A=
Date:   Wed, 8 Dec 2021 00:09:03 +0000
Message-ID: <BYAPR02MB4071BFEFB87D0B2E4FC98C9EE26F9@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <YYRjbCDhEt8Vh1xv@gmail.com>
In-Reply-To: <YYRjbCDhEt8Vh1xv@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qti.qualcomm.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 51159644-dab1-4d4d-cd7a-08d9b9def177
x-ms-traffictypediagnostic: SJ0PR02MB7853:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR02MB7853C3FAA60DADB5CFD64E92E26F9@SJ0PR02MB7853.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q+4wKRCFjXDLWwzk1Qv108vmm13ZgUV3IxuY7wO8Ua+SIE5msSrP499efVgwreL/+6/9VRVEvzkUyurLV3UtFt6OY0xToZvAk6mGr/Cn7WbaIKwilqCeNgHcGXX4FNyobdLtHEsssodaheFV854slul7chDZ/+BylUJ3JrN4YUnjsZ664VIvmSqVsD9yiKFIfuPC6y2urBNPNmUIOXDgW8afZfYABBpUP5GxG2A1nJzW//ik6wTgr1UqfxIToiKGVqn00AKmXIMIAtWtbgzwYjuSNv0momF670YkMe4eJ0CaUZOFe/8ynJ/RcuKKxh0V/apq/4ffQUGfoCvRgDIj9APG9usbC4MRHxUZnWlp5dloJ/VcxhFFZ7mC016MEZdaSMBHGY+CMpsUkdyseo1Xxs3yV+baXcimKHIGV8hiMNRMwSV+7Fa25a1xVBxzAtEMfNJmNibCJzOumZfjpGE4XR8wGnYR6idIYM0TV1Z3AUKQSfx2PoorIXTs1roAJ3P15OPylrCeEOxT5oGrYNJKLO4TpmoEY4Z2r7AZ7SVrF1WmgbP/upOrUhY3HnJkLK7FAdYcAobU26fLFQt3ulbl8rEr+g3J5uFCsj8ivPZG1rVPqvO8oQwbqfmMkRqFMQe6kRgXtdWElCNFRsGJRvPQRgHdtyRzvYcAkfzLyTskPFFmzJcVaqFiA9p/aBDnZsqMhrBbMx2G85pwIpGsafaoMapAuJPVz1yPT38SpTIFmkCr2czH1aNaNPoHj1sm1OQ249HeQozGEYomZc2Y1wLYHrtTG/Z+GSF85klohN57Oe8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(52536014)(110136005)(71200400001)(9686003)(8676002)(33656002)(122000001)(55016003)(316002)(8936002)(5660300002)(26005)(64756008)(186003)(76116006)(66476007)(86362001)(2906002)(38100700002)(6506007)(53546011)(66446008)(66556008)(38070700005)(7696005)(83380400001)(4326008)(508600001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QxyGcu4RlMN5MdPfxfzoppRpk1IVdgAb2hUpFpSheetjdZfNcKLkpW30xUil?=
 =?us-ascii?Q?82cymqMVk7a01jSyjWNgJh1o8+5G1g3TqCvyIYGfa9R0oH7PLc5xvVmGo70j?=
 =?us-ascii?Q?ERCe2/JLe50ZzP3qhNK/TIp8GXYWU8KeX3A8TZuyB1fikK3zmdVkkko4e5FX?=
 =?us-ascii?Q?9+QuC/bB3kDdFBVB4+7YupbL678zK9N5aN1QhezyW6PfCpCBU4CgZYwiqMoy?=
 =?us-ascii?Q?DigZbKLQHLn/mud33OJ0jQxbRc5IyksFFNDkAWxRrmH+vEVlmqtRkAk0ivU8?=
 =?us-ascii?Q?bRqjFUaE/lpGev9LiIfu8my150pRBEqiSHwfN7sGx7seH5hA8scLMa78H9Eu?=
 =?us-ascii?Q?40tVSU/0P3ax1glPaR8GLs9vrWWuuQ6qfjtcL5IbfFDzFAaE52YdXNKyOBTb?=
 =?us-ascii?Q?UT6ag+1EK5/w63elJUy47Iu3l1Fh8ocqCgc0SwKr9C4YQXa0/44YVohsmDcR?=
 =?us-ascii?Q?De43IB9zSogxte4ui8SZ0zDTo4tq8hrZOdsRFPdSEY5ssY1tyDPC3xJPtLFi?=
 =?us-ascii?Q?OfDFYRG2vMmXZ+x4hpEDpom4m8c5hECfIHdtFH7lBY6CMmjsvUOyLDwLtiQn?=
 =?us-ascii?Q?SGb3MbokH+SzDI7U8ji87HE8khMhM6xNzWYBjCvNrn5vr+2EXRmBXw5+fE5D?=
 =?us-ascii?Q?7OIP/lM3/l/flprRV0bnJE48ctmrFk+A5OdwXlZGQHOi9mhwxydLTRxQzSk8?=
 =?us-ascii?Q?OvJkxZPJx6MdrI21exO65/hmRCLGR2mn4Ai/2T3bODIZSoYrsnrZbnLqc8ts?=
 =?us-ascii?Q?SlwW0rWwaKO3FuwS8J/UqpIHZcQjsBdZUgGkqAOAYRTbbBFNPGx8TcRTO/NV?=
 =?us-ascii?Q?0oVP+GfASeLy333dCDQf3d8RngV6Pf4/ekLFZgFCHnFIVPUkZF+3Wn8KTXoV?=
 =?us-ascii?Q?ejAQ7HsP3VpVEt5wQNSwmKbfP+tLC73OfKjfixHNge2rBWKwMFZsqvlmU9si?=
 =?us-ascii?Q?E55/CGdcI+Wyq/1tQf7mQ+1uv90ZNJ1l06h5/gWpEsS0bV8usGNAuKgc3T+u?=
 =?us-ascii?Q?5+nRpnohYlCMsfmDCp3Kl0dRpxhbkoF2zcOuoT/vz6C2v4rlFUPOkwnaY4+K?=
 =?us-ascii?Q?5OgaSnYmMlDLe9e7kmcDYY9Hpig2V5XKlpPE9s8FGXJBkdixP2pupOFBF5kY?=
 =?us-ascii?Q?p7jdRnbwmihOTDPfjQeL4Uo8wQ0yCXzllfeWFC2K6TsA/zsthIFkaqKTD4Jm?=
 =?us-ascii?Q?r9mGTic6DSd0HoWZMBywCd/P3tw9FbYZKUpi70k/Z/wBWDR0npfML5YoZkgO?=
 =?us-ascii?Q?QtAQP4iBM4ZgBUu6nMfwVul3nOeoI/h984fQeB96B/MWkzELYPL6/LEHLkmj?=
 =?us-ascii?Q?NNrBMB2Fee9lW8rSUJALrOXMUPmz3HkOXxm1EZXRVw2rrQ+hx6YRgVYBo6BT?=
 =?us-ascii?Q?G/cqAW5zrNkUbGPbv6XKkiDb82XBxoQZdFHdPJfqiE2UHiuLrb+W5M8lr2T0?=
 =?us-ascii?Q?zCXmcZJm+SEPvxHzypXrdUrIJtMZkXxKbfi7rpByNWjojFsT3uP0hpk3C/jq?=
 =?us-ascii?Q?Xt9PFCUUU7V8cvpmFI5gVLtwJlaMGHWGQtm8wlAwq0wcuGI0iylKx16OvEYf?=
 =?us-ascii?Q?Ck/Ee7Uwgp4FmBS9zcWFER+fl92233zg1GktWuahaZb7FnBBxcYMo5Zg7E1u?=
 =?us-ascii?Q?jh20tWl+CJ35FoeGHoXACB7eIQqIgXKIpoYUu436JZbV55ZCTCEdqnYkTKVc?=
 =?us-ascii?Q?QkxpZw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51159644-dab1-4d4d-cd7a-08d9b9def177
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 00:09:03.3645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pG1924sDimJt18CpBfJ7QgIHfu0k+IBU0FY5Rw6Uqu39Ks+KArhaun1VaQpDixuD3YSJ9a3UjkZj/DySxz1gVEOG/U91O1zMM2fp23+V0Ms=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7853
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hey Eric, here are the answers to some of the questions across all the patc=
hes

Also, at runtime, does any of the Qualcomm hardware support multiple key ty=
pes, and if so can they be used at the same time?

- 	Currently, with hardware key manager data path, there is no support for =
standard keys. So, when HWKM is being used, only wrapped keys are supported=
.
	If standard keys need to be supported, it can be, but modifications are re=
quired within trustzone.

> However, when keys are hardware wrapped, it can be only unwrapped by=20
> Qualcomm Trustzone.
Qualcomm Trustzone is software.  There is a mode where it passes the key to=
 the actual HWKM hardware as intended, right?

-	That's right, trustzone does not perform any unwrap, it is done by the ha=
rdware. It was a wrong explanation from my end.

Please make the semantics of the @secret_size parameter clear.  Will the ou=
tput be at least @secret_size, exactly @secret_size, or at most @secret_siz=
e?
- 	Updated this in the latest patches.

Warm Regards,
Gaurav Kashyap

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Thursday, November 4, 2021 3:49 PM
To: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-mmc@vg=
er.kernel.org; linux-block@vger.kernel.org; linux-fscrypt@vger.kernel.org; =
thara.gopinath@linaro.org; asutoshd@codeaurora.org
Subject: Re: [PATCH 0/4] Adds wrapped key support for inline storage encryp=
tion

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

Hi Gaurav,

On Wed, Nov 03, 2021 at 04:18:36PM -0700, Gaurav Kashyap wrote:
> This currently has 4 patches with another coming in shortly for MMC.
>
> 1. Moves ICE functionality to a common library, so that different storage=
 controllers can use it.
> 2. Adds a SCM call for derive raw secret needed for wrapped keys.
> 3. Adds a hardware key manager library needed for wrapped keys.
> 4. Adds wrapped key support in ufs for storage encryption
>
> Gaurav Kashyap (4):
>   ufs: move ICE functionality to a common library
>   qcom_scm: scm call for deriving a software secret
>   soc: qcom: add HWKM library for storage encryption
>   soc: qcom: add wrapped key support for ICE
>
>  drivers/firmware/qcom_scm.c       |  61 +++++++
>  drivers/firmware/qcom_scm.h       |   1 +
>  drivers/scsi/ufs/ufs-qcom-ice.c   | 200 ++++++-----------------
>  drivers/scsi/ufs/ufs-qcom.c       |   1 +
>  drivers/scsi/ufs/ufs-qcom.h       |   5 +
>  drivers/scsi/ufs/ufshcd-crypto.c  |  47 ++++--
>  drivers/scsi/ufs/ufshcd.h         |   5 +
>  drivers/soc/qcom/Kconfig          |  14 ++
>  drivers/soc/qcom/Makefile         |   2 +
>  drivers/soc/qcom/qti-ice-common.c | 215 +++++++++++++++++++++++++
>  drivers/soc/qcom/qti-ice-hwkm.c   |  77 +++++++++
>  drivers/soc/qcom/qti-ice-regs.h   | 257 ++++++++++++++++++++++++++++++
>  include/linux/qcom_scm.h          |   5 +
>  include/linux/qti-ice-common.h    |  37 +++++
>  14 files changed, 766 insertions(+), 161 deletions(-)  create mode=20
> 100644 drivers/soc/qcom/qti-ice-common.c  create mode 100644=20
> drivers/soc/qcom/qti-ice-hwkm.c  create mode 100644=20
> drivers/soc/qcom/qti-ice-regs.h  create mode 100644=20
> include/linux/qti-ice-common.h

Thanks for the patches!  These are on top of my patchset "[RFC PATCH v2 0/5=
] Support for hardware-wrapped inline encryption keys"
(https://lore.kernel.org/linux-block/20210916174928.65529-1-ebiggers@kernel=
.org),
right?  You should mention that in your cover letter, so that it's possible=
 for people to apply your patches for reviewing or testing, and also to pro=
vide context about what this feature is and why it is important.

As part of that, it would be helpful to specifically mention the documentat=
ion for hardware-wrapped keys in Documentation/block/inline-encryption.rst =
that I included in my patchset.  It provides a lot of background informatio=
n that your patches are hard to understand without (at least your patches 2=
-4; your first patch isn't dependent on the hardware-wrapped keys feature).

Can you include information about how your patches were tested?  That's rea=
lly important to include.

Please run './scripts/checkpatch.pl' on your patches, as recommended in Doc=
umentation/process/submitting-patches.rst.  It can catch a lot of issues.

Please use the imperative tense, like "add wrapped key support" rather than=
 "adds wrapped key support".

I'll leave some more comments on the individual patches.

- Eric
