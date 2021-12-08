Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070D346DACE
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Dec 2021 19:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbhLHSRB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Dec 2021 13:17:01 -0500
Received: from esa.hc3962-90.iphmx.com ([216.71.142.165]:4452 "EHLO
        esa.hc3962-90.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhLHSRA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Dec 2021 13:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qccesdkim1; t=1638987209; x=1639592009;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oNtCErQlwVCPlqLTQjCI23pZW0aC/oqS6pGC6hTzXxs=;
  b=2dtpOd3BYw/7YARY6iDbtt/V9hwILpw1nAy8KFZ1LdOci1Vv66MUJZ2E
   DXYcUIRwY9z/3RhzUBV/WZLfIU1bDZnqZc6yB9eV1ekuCxc1ZH4i6Ur1o
   gYTmdmfeGX00KlFDElzydoleXywnbwrErg8UMERbJxLmti4tmUAe1rXXt
   Q=;
Received: from mail-dm6nam11lp2172.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.172])
  by ob1.hc3962-90.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2021 18:13:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQixHdAZMXPW2vTffHghoReHUXoyzbdR3ltPlAaN649/ZSFnd9X3pNiIswoXbBm9q4x57aC2ws2fiJ4TtlVHXQse0z2Hn2sS8dw53ciUPO1j7cfIo2Jdl0rvvtyE3fx+PQ5cp6KcQUZFKDO9dpXkKwv3prD+uhUIdimHYcy0Agwx/Gtjt5EE81qqe3g3QmSZdojXGdFRnqd5eaw5j5q2YSgf8kEWjRG2UXSn2RCJ9V/+iz7pVjIczfBnHFJ7CVWDQSppaKSrFq5HcpcuO3YOa4gqwWC96/0arZKk4aPnpqKFpcAZcEhZzglVp4v5XE0iFPQ73DUfxCnaNweLg5pSGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNtCErQlwVCPlqLTQjCI23pZW0aC/oqS6pGC6hTzXxs=;
 b=b0v6cUyG9Ve8xVvkyEt13uiLJ9f8g0alHxRHoZru0CvSYNuBAAft3e92DvINZUXAHrsPbiynOZUEW1auyEigvm1c8X6YrG0XH4qXcZ+VyTpc0G6iZCW2yJCrIMlaCOyYois+4/e5m/Po1DbmyjjvO5GVPjfsXev28CwKZYgKWCqS4hE8pfizf2IrDoGs3sDwDs3AjrsPG8PdiL/1wdkCooQxqT3v0buUvkC7zDk0aGLJl0AQb8Tqi8mz0hQfbx5q1uiII0PIApD+DEyejtybqOYBqmtnacdXWh1G82bgJCs1xB0RHNunNHxwJ8tZ9HRUB52lg1gd8aAzCga+onhzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from BYAPR02MB4071.namprd02.prod.outlook.com (2603:10b6:a02:fc::23)
 by BYAPR02MB5336.namprd02.prod.outlook.com (2603:10b6:a03:67::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 18:13:25 +0000
Received: from BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::7028:1b1c:7c3c:d15e]) by BYAPR02MB4071.namprd02.prod.outlook.com
 ([fe80::7028:1b1c:7c3c:d15e%6]) with mapi id 15.20.4755.022; Wed, 8 Dec 2021
 18:13:25 +0000
From:   Gaurav Kashyap <gaurkash@qti.qualcomm.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "Gaurav Kashyap (QUIC)" <quic_gaurkash@quicinc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
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
Thread-Index: AQHX0Qk30OEZMGexr0eC03luU1yS+qvz+lEAgDPzA3CAAAQrAIABKYKw
Date:   Wed, 8 Dec 2021 18:13:25 +0000
Message-ID: <BYAPR02MB40716E8FA91F8736A2736094E26F9@BYAPR02MB4071.namprd02.prod.outlook.com>
References: <20211103231840.115521-1-quic_gaurkash@quicinc.com>
 <YYRjbCDhEt8Vh1xv@gmail.com>
 <BYAPR02MB4071BFEFB87D0B2E4FC98C9EE26F9@BYAPR02MB4071.namprd02.prod.outlook.com>
 <Ya/68GveS/hWhJD3@sol.localdomain>
In-Reply-To: <Ya/68GveS/hWhJD3@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=qti.qualcomm.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2d91538-ab3e-481d-7797-08d9ba766d8d
x-ms-traffictypediagnostic: BYAPR02MB5336:EE_
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR02MB5336FE306B4DD286947A5203E26F9@BYAPR02MB5336.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 11Cbz7txUZugkSo59Mrgg05n9JZpSdX0vH0IF9Jk7gvYWuFjqLW2Oiq/Y/qDKorVemv5XDltqIjsgcRZv5oTvU8RRFLO+AxKzvEvAZ9L9UfuUAO2L1NCbShDrk0Iy8bdyd89OPO6v+a3iqwXTd+sqD4UeBaB5Hf/cKeMyZVAQhyjqa5FlPbXxLLiDqp9EByQy7HO+GkYQ37qyk8QnPcMCxo2O0cxyXU5uebkELMLv+LyfwpX3Bna4miFVcbmlA7iCDyX8Y6ZpMbH4W8q3COfniTWjVzQzs8L8FwV1+rdVUuJUbuwuMpSy6BpkCdYQvsMxVxqfzpHPyHbF/bQEI5sZq0fGMCRQfksG74ADd53wR2MmEeYZX3AchzRgRtkAY7vFx6eo75reAeEDKb3HJTf5Iw7htHvJW3QxcUMXxiJqNbPudxHp3yzG8oEMnxN7TGtaHbtmIuOiu2KwPrPHt7YLcgFEQck8F9RRIlfcpBfDApVv5xwTWQw4fRjrK6u4OKL+ofYE78IW80TxWgTGB5a5CG0/yKxGp+TsS+DmVCrf0AMYoZ6MzsAytxrIqGpKzsuRts/bp8B+25s8JPdj8+DW5vXqmU0j9oEb337BEd/1AYQ/v30T9KH7GnyetmkGr1S4fBtJtZNaYdPTmUam5GFHFw6obYdT150Hu8feR9LPXdBpnla8fTJruHqx5z2i2ZQzKntQw6UntoCLRE0k8L8ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB4071.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(38100700002)(54906003)(316002)(6916009)(38070700005)(6506007)(186003)(26005)(53546011)(5660300002)(8936002)(122000001)(83380400001)(4326008)(55016003)(8676002)(2906002)(71200400001)(9686003)(76116006)(66446008)(64756008)(33656002)(66556008)(52536014)(508600001)(66946007)(86362001)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QNfdYdFHiHAFg3sxEok577TCZt9PHXgaDgqLbNbsI4DSRw6oE1ne/wPHsNNU?=
 =?us-ascii?Q?IZFbVKSLZxRJXFjfmrhKxNJAZHTqaKq5T6lN/XkV/vdmANj3SZs79AnO24jg?=
 =?us-ascii?Q?YVNkyk5kSAaPmn7373OWk4ABUc93AYZrDEX7wHYcbbFD3V1rZzLjJnHOda+W?=
 =?us-ascii?Q?dWSN/zJP3RGAWa3oaCPoAxOiKfRry4M4BNIomFJay/O+SSIUxhIApPw6Bm0z?=
 =?us-ascii?Q?+iTG4F7zVcQE3tYhEaSL24hdnUju2ut/8HDyuaiv56RBhNy/BN+P4zuUmVQM?=
 =?us-ascii?Q?wfI8jbLobIRcd/oGkNCllz0sBKMTIUdHpxK9ocvB0nSmIII6NRGszQc9zQSP?=
 =?us-ascii?Q?XLRTXbET9W8NO/3zbHVu3IdUW2BFOayEE10NMQCJIIV/76Lnero8W8kOLPFO?=
 =?us-ascii?Q?sAJIwJuQhIT6XLQ5KAskjBBEXUZZhXb4l0TYMJwHMR6ri7OVZGPSvgI2Vbs+?=
 =?us-ascii?Q?Nkc8lmDa5rsChgR1b/9lNiRZZfT5pY/1lkWjsQvM13GzHaQNEg3RIWQcFJe9?=
 =?us-ascii?Q?k0z3e8iPcf3r5/OQdSy9tczWDnbbOJHRYpyCtJGYnRyQRH5Q3CAQRsC9XYdR?=
 =?us-ascii?Q?eXy8hoKEe+w3tyapQrw50nEjOF8I4F+gy/zXkEZmt4pgSwrRGwTsEXuBtQlU?=
 =?us-ascii?Q?mcKkNbST2wXE7P9hqX+hwr9sU1FofRU9qrcB5LK4nGa3XgrbWnUE3aDc8e9M?=
 =?us-ascii?Q?nXGcsaKUH3ZPfwOLobSQD3rujlNnk4H+XXcMEX0NAcIzYJ6mytZNTBrbZmSe?=
 =?us-ascii?Q?sVqClHtuKiF7Zae7jz8YOvN0R7pp9pjmzaIP3xUvpF3iuQOpVZpAL7mjgBsi?=
 =?us-ascii?Q?HOd91wWmFkZ09gd3s8OmofqV7ksZAFZmLnMgnG3BCDDXkNBgua2iEWDYOXtn?=
 =?us-ascii?Q?MnYA+icYxJvTkquXrL5frYHeSXhhp6U9tVG/JvCnL8OvaS9j/vx1DbLGEJno?=
 =?us-ascii?Q?IQ6xQA9K0bmRGutNSR7NJzgNQRbXuJN/ZFZTrH5bkwB/yLCsjUg0XiCSYzSR?=
 =?us-ascii?Q?xjp+d47+sM0CvVuCXXdcFRfQnCFuubpmqeSzUaF8b5pEG/lxJiiSb6zJaSad?=
 =?us-ascii?Q?N6DIwiZ6majnJiBMK11uO5Y9jA9jAs84bqIRu4zq55+cKG5ZX23J7xnSf03V?=
 =?us-ascii?Q?nvrW3yXBHfxfbi0WCiqcjxbpNT96kSgADe+POurTEK/TpO5IesRrLvAac1VH?=
 =?us-ascii?Q?5Lh/+5CE+2CRKYb2QQgx5BIUw35CnsRnSJ0/BrIF+EUZNpijY3gf4py/TQ0D?=
 =?us-ascii?Q?7S4Nyo8ofCWKjSvJj26TWtAn6VJKSNkUXuzDMcti8lTN8Yi79KqvF9nMCoPe?=
 =?us-ascii?Q?InnkaG9jR5EpWb0XMnbBbdeQZA1mHBLpbrKQVzvXVskyIQt9D5AjMrVTxwSl?=
 =?us-ascii?Q?nCnYyQIbz0mgdbW4GduWHHczWtg7FK6QgDFZZg+ufcL6DMuMCxhOHVmEWiIQ?=
 =?us-ascii?Q?qPs1VBhTYx3C4h0VkGGU+xuJfpKC5DzovDEjbe3K2sxL2V5cQc9X1T41oiLT?=
 =?us-ascii?Q?4ijs06X0IxeI73j1sy2oYV7MItXnV3LGFdpap8ImiAS3cCyd8AhtgOkkxOhA?=
 =?us-ascii?Q?Vlx0Tx0Uo/8HpzSJlBP3Uzk9EX2yNJQ9q1pA+4UyKudh2a759LGnRI3mG4t2?=
 =?us-ascii?Q?xiGdyxyQS0tyArb3H2U4JMwLKFqoxdN5SGKXMpODymTSMoni/HBJ/x1z7xgu?=
 =?us-ascii?Q?/y8Dxw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR02MB4071.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d91538-ab3e-481d-7797-08d9ba766d8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2021 18:13:25.5111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uq+JGxZJ6v8zT3oF0ehUk35RfHLNDJNIBtBnMYfsbNX4lh+3Gm+2Oy/YJUqMGS5VGDV31CvJ/jS4qOlX+LeCEfjEM70ATC2itcokBuu0q/0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5336
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



Warm Regards,
Gaurav Kashyap

-----Original Message-----
From: Eric Biggers <ebiggers@kernel.org>=20
Sent: Tuesday, December 7, 2021 4:23 PM
To: Gaurav Kashyap <gaurkash@qti.qualcomm.com>
Cc: Gaurav Kashyap (QUIC) <quic_gaurkash@quicinc.com>; linux-scsi@vger.kern=
el.org; linux-arm-msm@vger.kernel.org; linux-mmc@vger.kernel.org; linux-blo=
ck@vger.kernel.org; linux-fscrypt@vger.kernel.org; thara.gopinath@linaro.or=
g; asutoshd@codeaurora.org
Subject: Re: [PATCH 0/4] Adds wrapped key support for inline storage encryp=
tion

WARNING: This email originated from outside of Qualcomm. Please be wary of =
any links or attachments, and do not enable macros.

On Wed, Dec 08, 2021 at 12:09:03AM +0000, Gaurav Kashyap wrote:
> Hey Eric, here are the answers to some of the questions across all the=20
> patches
>
> > Also, at runtime, does any of the Qualcomm hardware support multiple=20
> > key types, and if so can they be used at the same time?
>
> Currently, with hardware key manager data path, there is no support=20
> for standard keys. So, when HWKM is being used, only wrapped keys are sup=
ported.
> If standard keys need to be supported, it can be, but modifications=20
> are required within trustzone.

> Do the SoCs support both key types though, just not at the same time?  E.=
g. when the ufs_qcom driver loads on SM8350, could it choose to expose eith=
er standard key support or wrapped key support, or is it predetermined by t=
he hardware and/or firmware?  If the driver has a choice, > then there shou=
ld be a kernel module parameter (module_param()) that controls it, so that =
the user can choose which key type they want when they boot their kernel.
=09
As of now, it is predetermined in TZ firmware. As in, if TZ has booted up w=
ith HWKM support, only wrapped keys are supported. But it is not impossible=
 for HWKM to support standard keys as well, it is just that currently there=
 is no path in TZ for standard keys when HWKM is being used.
=09

- Eric
