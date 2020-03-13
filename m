Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE5E184D2F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Mar 2020 18:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgCMRFl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Mar 2020 13:05:41 -0400
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:35743 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726526AbgCMRFl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Mar 2020 13:05:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1584119140; x=1615655140;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=SQV7PpaTmHssJ3LNbavIfORV1ijwr6J+zAVSqZdcNkk=;
  b=gARDzDmMfgdGxKHBxY9Nf3VfE89Y5WCaqn+GY+qKRkk4l1fByHmSa6Ne
   9DFB3SAKoPR1ny1agmtZpLma3VSJEshxhILX3OrLpzVOA75KRNbF/q6fC
   gzHosXxotAlZeCSQA5vrlhVRXindmUn5cfg/VncaWYO279zfiTwFvOeiY
   g=;
Subject: RE: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine support
Thread-Topic: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Engine support
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 13 Mar 2020 10:05:40 -0700
Received: from nasanexm03c.na.qualcomm.com ([10.85.0.106])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/AES256-SHA; 13 Mar 2020 10:05:39 -0700
Received: from eusanexr01b.eu.qualcomm.com (10.85.0.99) by
 nasanexm03c.na.qualcomm.com (10.85.0.106) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 13 Mar 2020 10:05:38 -0700
Received: from NASANEXM01G.na.qualcomm.com (10.85.0.33) by
 eusanexr01b.eu.qualcomm.com (10.85.0.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 13 Mar 2020 10:05:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (199.106.107.6)
 by NASANEXM01G.na.qualcomm.com (10.85.0.33) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Fri, 13 Mar 2020 10:05:36 -0700
Received: from BY5PR02MB6577.namprd02.prod.outlook.com (2603:10b6:a03:20d::13)
 by BY5PR02MB6929.namprd02.prod.outlook.com (2603:10b6:a03:230::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Fri, 13 Mar
 2020 17:05:35 +0000
Received: from BY5PR02MB6577.namprd02.prod.outlook.com
 ([fe80::5d38:9a6b:aab1:f9c9]) by BY5PR02MB6577.namprd02.prod.outlook.com
 ([fe80::5d38:9a6b:aab1:f9c9%5]) with mapi id 15.20.2814.007; Fri, 13 Mar 2020
 17:05:35 +0000
From:   Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
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
Thread-Index: AQHV+KFF2A3EnezVtke6LRrkIEzOAqhFUyMQ
Date:   Fri, 13 Mar 2020 17:05:35 +0000
Message-ID: <BY5PR02MB6577DA7FD4425C8D7F318E2BFFFA0@BY5PR02MB6577.namprd02.prod.outlook.com>
References: <20200312171259.151442-1-ebiggers@kernel.org>
 <20200312171259.151442-5-ebiggers@kernel.org>
 <BY5PR02MB65778B0D07AA92F6AB5E39E8FFFD0@BY5PR02MB6577.namprd02.prod.outlook.com>
 <20200312190541.GB6470@sol.localdomain>
In-Reply-To: <20200312190541.GB6470@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=bmuthuku@qti.qualcomm.com; 
x-originating-ip: [76.176.48.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 952b9e02-2ab0-44fd-d228-08d7c770bf25
x-ms-traffictypediagnostic: BY5PR02MB6929:
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB6929C98D2A717E140483F0A8FFFA0@BY5PR02MB6929.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 034119E4F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(396003)(346002)(39860400002)(199004)(52536014)(81166006)(6506007)(4326008)(53546011)(6916009)(76116006)(8676002)(66946007)(8936002)(66556008)(2906002)(66446008)(186003)(7696005)(66476007)(64756008)(55016002)(5660300002)(26005)(71200400001)(86362001)(81156014)(7416002)(54906003)(33656002)(478600001)(316002)(9686003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR02MB6929;H:BY5PR02MB6577.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XnLEl36K96pqRVWaU4gnjReabOxRp6Qpb6x8d1UPqWU6T3XgnBClITqR4d31IwR9x/g/CdlfsKyKrbDv0LEAl6Km2RY65RpbN5d9Pwa0hZFxYH5MLfhO4NifRh7F440q5G8K/ji5bA/GMWdI8nxYANZ6Ueun3lVtZ8DUZosG2+9Nknl46zDQ5fQWasrntxIh/C4zmS7p+R+th636xvdmKIuES+Uzx65qjQ2Eln7UeM6uIKynmclwDAI68gb9Sw/awCLf2/NRedpq/I4e7DxOdDP9LPCi3F0FbsGsFye5z+VQ51FZ/IgmFNL4QYBE5SyPLi4G92H4DpG1ze8GjSIjSu4emNM4nwXOLRDJWDv+yYBLL0+7LumQxd1sM+317bfucIUMO8+R8WFPlVE32iKfPLXwJ21Ta8FcojkMC96XgNH7OEKH0K+Z9awvRtfOkwVH
x-ms-exchange-antispam-messagedata: xgjwNWFEjGoNT5i97A4qKw6bfhhtHxXAGChbHWRirtF2t1gZ5scSZldF/uwKirNxxdwrcJMZhZqIg/8Q1NrAnivIZQbxgLbqNSItljFx27g66bjwfragbDlChQ+hn7PkrvOy/T5TIN511Af9uwaLMg==
x-ms-exchange-transport-forked: True
arc-seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gr3igG6FWA3FhlWCsjM4By8H/dZVlbd5Mwg2rZ71kjTMnTD4UkDAI5+6kPobkaaIdHzHIsuBzE0qyZoJPwr5wZfpRf//o5H5MWvH3GdMTPyJ8wwLZxuWPvpiZalq3Kouj3JY0Ul/gOyvqYxfP4w6+7hn5IXUntANUlJzu8/es0GuwBZTTpJFVy+YhDV//LFf45Bx76iTCKdUSgczTzRDnBoZNmskZdQmuPAcdbwYm24U4sf7Zc4WkVDVEJrtT7Qjb3QizGUbc4IBQFQIdcO/DCsx77PnsnqMqCZI6PPm8gtWXBRifUtx06IS5ZAEebFPZMXWqStp/PUnUt+JVl3XeQ==
arc-message-signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgR6ly1o4L+BDNgno3R0iX+Y+6aoA8lJjVcUzna9lkY=;
 b=UT7pSFQjMACwfN2cDUHHGa9+ye4CneGLVsYhqG2KrU5qduqWdV/ROyFllaWnfWQo+vgsg+Qtw7d+/n/6XTyvMwzC7rbxSof5qwDMICquWq/7fhahEae7UZT4UopS/VaZdSqvdRQTChWcBsVCgLMyxhfVXgL9VZ1L+CTwB62NciOVEfRsioXIkXdMhdoBvNwJtbT2/deZWA99BymroC0xThZ4O9cXajTFXsgz5epPKUrlVrSTHJrXCqkaHoroDlRjWEeRtAb/MiZscSMId7v7KCF+vylDxVccIGllLRz5AN0GfQy34MdebChBd/wiDuPZPz+AVieLrg0NbHDKgKzO0w==
arc-authentication-results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
dkim-signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=qualcomm.onmicrosoft.com; s=selector1-qualcomm-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SgR6ly1o4L+BDNgno3R0iX+Y+6aoA8lJjVcUzna9lkY=;
 b=SvMHsQbCXlp175mJ5Eh9pVu4NMN1nsFNonXCFUay38/z51SKEWjVvyofyPmA6lf0hN34LfEvcLjSlEkPvxNw5T9KAmua16WwHsgjp/Xu61Udy70Pw1TCmdGzhHvgWI20Catj9BZQenENm0vQi8sNdLaWfPyQzuQ8OGUVKx3MuZg=
x-ms-exchange-crosstenant-network-message-id: 952b9e02-2ab0-44fd-d228-08d7c770bf25
x-ms-exchange-crosstenant-originalarrivaltime: 13 Mar 2020 17:05:35.1245 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: KsmUVVedIyzQckfcniJ6JSU4NIBwjDxzch17vT/Z5qdNJpXfT/Jsy+QCRkGb6XuXDoJ8EZQqsVqtz8B4Fyqw+0tgq7cDVdx0YkYnAPUXImU=
x-ms-exchange-transport-crosstenantheadersstamped: BY5PR02MB6929
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

The crypto_variant_ops exposed were not a guess, we had worked with Satya t=
o add the functionality that is required.

Can we define the below crypto_variant_ops that exposes the same functional=
ity you have added, this allows us to extend this in the future in a seamle=
ss manner. As an example QC implementation uses 'debug', 'suspend' and we c=
an add that when we upstream the implementation in the next few weeks once =
our validation is complete. Thanks.

struct ufs_hba_crypto_variant_ops {
int (*hba_init_crypto)(struct ufs_hba *hba,
       const struct keyslot_mgmt_ll_ops *ksm_ops);
void (*enable)(struct ufs_hba *hba);
int (*resume)(struct ufs_hba *hba);
int (*program_key(struct ufs_hba *hba,
      const union ufs_crypto_cfg_entry *cfg, int slot);
};

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>
Sent: Thursday, March 12, 2020 12:06 PM
To: Barani Muthukumaran <bmuthuku@qti.qualcomm.com>
Cc: linux-scsi@vger.kernel.org; linux-arm-msm@vger.kernel.org; linux-block@=
vger.kernel.org; linux-fscrypt@vger.kernel.org; Alim Akhtar <alim.akhtar@sa=
msung.com>; Andy Gross <agross@kernel.org>; Avri Altman <avri.altman@wdc.co=
m>; bjorn.andersson@linaro.org; Can Guo <cang@codeaurora.org>; Elliot Berma=
n <eberman@codeaurora.org>; Jaegeuk Kim <jaegeuk@kernel.org>; John Stultz <=
john.stultz@linaro.org>; Satya Tangirala <satyat@google.com>
Subject: [EXT] Re: [RFC PATCH v3 4/4] scsi: ufs-qcom: add Inline Crypto Eng=
ine support

Hi Barani,

On Thu, Mar 12, 2020 at 06:21:02PM +0000, Barani Muthukumaran wrote:
> Hi Eric,
>
> I am confused on why you are trying to re-implement functions already
> present within the crypto_vops. Is there a reason why the ICE driver
> cannot register for KSM with its own function for keyslot_program and
> keyslot_evict and register for crypto_vops with its own functions for
> 'init/enable/disable/suspend/resume/debug'. Given that the ufs-crypto
> has the interface to do this why do we have to re-implement the same
> functionality with another set of functions. In addition in the future
> if for performance reasons (with per-file keys) we have to use
> passthrough KSM and use prepare/complete_lrbp_crypto that can easily be a=
dded as well.
>
> IMO the crypto_vops is a clean way for vendors to override the default
> functionality rather than using direct function calls from within the
> UFS driver and this can easily be extended for eMMC.

ufshcd_hba_crypto_variant_ops doesn't exist in the patchset for upstream.

We had to add ufshcd_hba_crypto_variant_ops out-of-tree to the Android comm=
on kernels to unblock vendors implementing their drivers this year, because=
 we didn't know exactly what functionality they'd need.  So we just had to =
guess and add ~10 different operations just in case people needed them.  (N=
ote that some or all of these may go away next year, once we see what was a=
ctually used.)

That's not acceptable for upstream.  For upstream we can only add variant o=
perations that are actually used by in-tree drivers.

So far the only hardware support actually proposed upstream are my patch fo=
r ufs-qcom, and Stanley's patch for ufs-mediatek.  ufs-qcom only needs
->program_key(), and ufs-mediatek doesn't need any new variant op.

So, that's why only ->program_key() has been proposed upstream thus far: it=
's the minimal functionality that's been demonstrated to be needed.

Of course, if someone actually posts patches to support hardware that diver=
ges from the UFS standard in new and "exciting" ways (whether it's another =
vendor's hardware or future Qualcomm hardware) then they'll need to post an=
y variant
operation(s) they need.  They need to be targetted to only the specific qui=
rk(s) needed, so that drivers don't have to unnecessarily re-implement stuf=
f.

- Eric
