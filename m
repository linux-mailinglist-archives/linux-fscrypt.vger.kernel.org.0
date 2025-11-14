Return-Path: <linux-fscrypt+bounces-967-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id D64B9C5ECFD
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 19:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 89E0E34F00C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Nov 2025 18:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C1A2D8774;
	Fri, 14 Nov 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fB4QMh7v"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1C225A38;
	Fri, 14 Nov 2025 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.158.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763143680; cv=fail; b=i8uoKrUwE+Bnt6b/zXxCUimhV8p8YDwjpLUxRLCrS5AmvU5ASkcsbHTZAQYQ6ccQEPdiI3IVe7e6KzIoKn3lV2qzPhidV4rGy0TPq7LLiJkHVCFGE8S9A3FIjEKu27OjQqbV6e1K4DHLcfjPpOHY4/wkJE5JfTJ1kSxE2N0zqCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763143680; c=relaxed/simple;
	bh=XYcv2GlNwKhRk0uXwnN9HkbV+lhjMIi1D0m1s/7RZJw=;
	h=From:To:CC:Date:Message-ID:References:In-Reply-To:Content-Type:
	 MIME-Version:Subject; b=Rikgj8I9tIZvmR3r7bZ/eL2DwU27ib2iDpvaIdTWrgM1/OxCYqDwasTzyFeZKULfewwFr0wA/YQLGJDnmOWcUdY8rtUVwOgin/j0SODSW4ztpv2F1vAqKbepQulyZttmhPz4ZEoxfNUOKemesVKJdph2/8KR7cNfgG4nRr6KGb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com; spf=pass smtp.mailfrom=ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fB4QMh7v; arc=fail smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AEE0reH029695;
	Fri, 14 Nov 2025 18:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	pp1; bh=XYcv2GlNwKhRk0uXwnN9HkbV+lhjMIi1D0m1s/7RZJw=; b=fB4QMh7v
	lWO+v/mFm+CrYzjq13feA96Yo0VNNkNjjAA6RkZOKn1S3ijDZEFfvLyUsAhmevC7
	rXEyS+aTeI0pHPN2ZofWEB7THoCaxURxixnBW395iojzq0u8kzhjuL5esC8aFk41
	2l+wcnMQLxGJaEM7ko7pcvgaJqUREjcgQotiesVNeGKw1j75QjTP35l/zUQ57GbH
	Px9/XUpgpirhQSFSA9i6QsUxKsAZtzq5/6u5IEWadlVPIZ8KDt7NciyP1YbzChw0
	w6qtlLFcTTLx3Eme3Xgs0DULBJdRe2TRUIk4S/bywmgH6e1sxifnIY19OcVuF0ss
	s3NnksVkFUMecg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4adrevm0qh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 18:07:30 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AEHw8RX013668;
	Fri, 14 Nov 2025 18:07:30 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013013.outbound.protection.outlook.com [40.107.201.13])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4adrevm0qc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Nov 2025 18:07:30 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gYXLF+gwuKVW/drrGkxSBKFVwEoiqG2ryLtsAq6t1QZnTFz45UupmdygEUVDFkJlkFyrz5DI/tpm5eurF7USONyoq+/acYMQB9exw+2kp/pmxFAzFf3zxiaJCAUndRoMAdWaT3rVjOO6NHRC6blxMsvALAWHyUpZ8ZOO7Xk0v8NkRTeU9eMdJMWWA4s2mQIKT5NTMgou/hv9Ge5Kc13AD8o/NrifiJnfWq4EZr2FoWuNpHYCxkLHxDyz9YheLQTTueakEB5M4mMllSvDdaKPeiwvnUyEjYswpxOKfd009mfNWIpQdUSxyK9EvavE4UIhqsJ0fQ4+IFY6ojFh0CK7FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XYcv2GlNwKhRk0uXwnN9HkbV+lhjMIi1D0m1s/7RZJw=;
 b=lgHX+p5qRQVaQNB3Cw/FaUaoEShtqXBQP9KF2obRd/DFN5rBUpDpWV24stZhnu5TyV2nVLjfHDjH46nh8ze1EQ2KUqTN5xLScATwkofVGSqBqA0/1vG1tPUthzonM6BctZEE2KOHxRoC2wmJ8uruyCYwVj4SaO902CB9NHtUmKbYLBuxr8G7kDp/Z/kVutgp4ypNaoYBbPjQCc+vV6nPrzvW8OREiOZ09ckDqFuBgA9yFPnCjurUo+0VFB/H1DtNn026Tptl40B2+av5MxboTGDibGrQjrUbPoQyj6cdu9ZAlLKPs5xxX1/6HqoFJn+EbECCv9nsAwOJXH/Jnjm6XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ibm.com; dmarc=pass action=none header.from=ibm.com; dkim=pass
 header.d=ibm.com; arc=none
Received: from SA1PR15MB5819.namprd15.prod.outlook.com (2603:10b6:806:338::8)
 by CH3PR15MB6045.namprd15.prod.outlook.com (2603:10b6:610:165::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.18; Fri, 14 Nov
 2025 18:07:27 +0000
Received: from SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539]) by SA1PR15MB5819.namprd15.prod.outlook.com
 ([fe80::920c:d2ba:5432:b539%4]) with mapi id 15.20.9320.013; Fri, 14 Nov 2025
 18:07:26 +0000
From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
To: "409411716@gms.tku.edu.tw" <409411716@gms.tku.edu.tw>
CC: "david.laight.linux@gmail.com" <david.laight.linux@gmail.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>,
        "kbusch@kernel.org"
	<kbusch@kernel.org>,
        "idryomov@gmail.com" <idryomov@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        Xiubo Li
	<xiubli@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "andriy.shevchenko@intel.com"
	<andriy.shevchenko@intel.com>,
        "hch@lst.de" <hch@lst.de>,
        "home7438072@gmail.com" <home7438072@gmail.com>,
        "axboe@kernel.dk"
	<axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
        "visitorckw@gmail.com"
	<visitorckw@gmail.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Thread-Topic: [EXTERNAL] [PATCH v5 6/6] ceph: replace local base64 helpers
 with lib/base64
Thread-Index: AQHcVSzDjM495O6mSEWuSsXBT/T4WLTyeLcA
Date: Fri, 14 Nov 2025 18:07:26 +0000
Message-ID: <afb5eb0324087792e1217577af6a2b90be21b327.camel@ibm.com>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	 <20251114060240.89965-1-409411716@gms.tku.edu.tw>
In-Reply-To: <20251114060240.89965-1-409411716@gms.tku.edu.tw>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5819:EE_|CH3PR15MB6045:EE_
x-ms-office365-filtering-correlation-id: 271d3d9b-5bc6-46e8-d46b-08de23a8ab4d
x-ld-processed: fcf67057-50c9-4ad4-98f3-ffca64add9e9,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|1800799024|7416014|366016|376014|7053199007|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?bGdraXZYd1NKVkFuUlNxL3J6VUMzek1pakhxc0wyRUhCeTB6b21UTkFkMnhk?=
 =?utf-8?B?cVVJMU4ybU1WTmlCZGtEQWVRSG1lZWRpYmkzd2wzQmFBLzB4eFR0c0hHZFQ1?=
 =?utf-8?B?QnF1eUc3NVlUNEJTeUJ3ZXdJV2tSdzFleTVzYzdTMTFuVG9ZMENZUHNOMGN4?=
 =?utf-8?B?L1pGUlpZWjljOForOW1VOWdJOXA1RENJK3BMUEJIZXV1ZytTSkxzK1NUWmgz?=
 =?utf-8?B?MktRRWxYOUtmcnFNRzFxV091UVZBalhrK3U3NEIyOXVsQWtoZzRaWC9uOStj?=
 =?utf-8?B?R3c2OFZ1OFF4dFE1M2VhSG5La09YQ21tMEFHaXNFSmtwdWNycTdYdFNhM1E5?=
 =?utf-8?B?WWNDbjd2R3F6dXMvZDBYMklpaTZKRGE2bWRPZFZCNGlyYjU4MzMxVEZZeE5I?=
 =?utf-8?B?c1R6cG56MWkzQ04yY2thTUlXWnFKWUNSVDMvRkYrODRCTmE2eUJ6WVBGa0dC?=
 =?utf-8?B?blZsTlg2Vm9XViszbExCWlZVMS9Mb1FsR1VLeXdNMHVpQjZzK1pFTlp6Sk5Y?=
 =?utf-8?B?QWYzS1pzYWJOczF5b29zRXo1KzMyR1J4NUgwMzc2RnJNcFdad3F6WDBkRVJx?=
 =?utf-8?B?a25WZXNhcm9IQS8rZDFxWmF3bDFJdEpydHpiZ2c0dzZiQStXSnRNQzArQy93?=
 =?utf-8?B?RmNxMkxHU1RWdnQrd1VvVEVJaUd0Q0VxVTd0U1lGTTBIRzdmdTd6N01YUmZz?=
 =?utf-8?B?N3Z0TytmQzhkaS9Uak1mdWgyZ0NhS1p4SVA5bHpRZStWb1dVcG0xL0xCajhO?=
 =?utf-8?B?WFgvOEg1MXNrVEp5OVNYZWc5WVBIQXV1VHp1NzhoTG9Na2t1bDF6cWo5UmNP?=
 =?utf-8?B?bG1mRTR4d3l6Q3ZHR1FscTVNaGpZdjZnRnlQcTJtWW5yRklwM0E5bm8yb1hI?=
 =?utf-8?B?SnkxM2piS1FZVjJTS0crbTBwZVJzWFltZ0pBeVZodEt2YndCU0VSU3BjYzc4?=
 =?utf-8?B?Qzg3Y2ZkeUhHS3o4MWZlQmdDSklsWXhxNVM4M2VveS9DL21LOXlSdk96MU1l?=
 =?utf-8?B?M0V6Z1RaYVU1VFNNc0dkMGlMR2dWU1FxdStQd0VzTHpmVE10eVZjaUVsNVVV?=
 =?utf-8?B?eEV5R1Zpb2tWWGRTdktxbTg5OTRzRGlmUFlBNk5udzVMV2xESXJHVkFzcFBF?=
 =?utf-8?B?dEptNElibGxMN29ZT2V4Q0V5Y3ZZdnlDb1EwUXoza2w3WGlXU0xTczVCQVVi?=
 =?utf-8?B?Vlh1eTFybTM4bERSQTI3YUsybi9aaG5xcWxMYTlYVDdPNWdJK3I5QUtkeVNx?=
 =?utf-8?B?UFFONDZPMWRzWms2Qmg2OWdWYmt5TkVselEwYVl3RUJZZzdWRTlQMmUzSHFH?=
 =?utf-8?B?QXJSUTNkNnpNZjFPei9FMUhUeXl3anNlR3BTNGYxazVOcklod2xyNHlVTmZX?=
 =?utf-8?B?bVptUjdzaTVVUkNSMWRYbGpWOHcyZ2gwdDgrUWN1enBkc3VFTmpZbXVVUVEr?=
 =?utf-8?B?M1pkWncvTmM4NWFPSGhtY0R3VjBXQ2lwSXlxWEtXUlo2Tit3NFRXbmE3WXZG?=
 =?utf-8?B?TTZQQWIrUmJITkEvMFdVZTBFcHpVeXE1ckJTZmZyL202WSszb3BTcHdLcGZV?=
 =?utf-8?B?OWVaaFlkWGNVMHpuRkhuVE5INXAvNTdoc1ZCTDlaNGxjbXlKWi8vQmJJRmpI?=
 =?utf-8?B?d0IrMEs2YWN6ZXQzcTFKNVdPSlhGb0lFeTFEY0crY1UwTllmcllPcDMvbzBI?=
 =?utf-8?B?SWdVYUJqblBvRk9ibDFaY2ZSYUZ3R2dPVlh1TnNlT3N4RVpHSDJzVHR3ZWZJ?=
 =?utf-8?B?S3VuZS83WTdOVVIrNDVtNndTWG05c29NV0VJbjY0T0h4aG5uSTJ2a2tTN3VJ?=
 =?utf-8?B?Zm9HL0U4MGQwYjZ2elU3aThrRzJKRERMdVZLU09hZWJMeGRiY1Z6VmphakxF?=
 =?utf-8?B?MjZSL2lTMXIrZTIzT0hLMTlvNjdtZ3V3ZWZMVE5iakNrK2M1bUNyY2JzaUNN?=
 =?utf-8?B?dnV0Rk1Qa2ZFTEVmV0VNQmYzbUNqZDJpZ2lnNDFvWU0wdDdZOERBR2JoZDZR?=
 =?utf-8?B?WThRaUxlbzFlZkcvN3hadW1YNktMMnNiT01JYXZlT0FOcEZKMGtDWGpBQzZt?=
 =?utf-8?Q?YjdjQN?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5819.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(366016)(376014)(7053199007)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WU9aVEJRNnVPOVpsTkh1enFqMldUd2ZtZm9WUjdZU2JXN2paZk5RVmFUK2ZB?=
 =?utf-8?B?VXBPUFMyb3hjdVJ3ekhyUUU4eXBkYS9yUnlUWkVPZjdQQnhtN2xRZ05hNURO?=
 =?utf-8?B?QjY1QkJwNlArOG1Rc3Z3ejQxRDNNQkFnWVV0TUQwcHIra2VrMjZvOFBaZGxP?=
 =?utf-8?B?L3lUdkg2aHAxaEV3Lzc5V2htZVpEUnBqREViNWdZcFAvbFMyNy81U1VHbFV3?=
 =?utf-8?B?YXd2a0FzYkt6VjFOZTc1eTFZeW15R3h3dzVmZWh0S2xVbGFNZVd6cXVTN0FW?=
 =?utf-8?B?a3NFY3VIdDhCM09qb2U3K2dnejZNZkhhT2lVTzBKNUdjeE82Z2cxYTlxWTly?=
 =?utf-8?B?WW13WlZTMndJTW8yZXdja2Y2OGJKVFM3bW5udU84eTIyTnpvaXBLVkQvWm1z?=
 =?utf-8?B?bldOZ1JRNXJsbkxEY01OSGtBK2xQeUVnWVNRQklRWUl3WnM0dUlSRGtJNkhs?=
 =?utf-8?B?QWd6QzEzQm9maVdwdVByYnBoTEdZdzBPOTc0Y3ptUkp5dEZKYzdPQ3A2QWVY?=
 =?utf-8?B?bGJVdlZ6QTZ3UnVIRER0S3JkRDZMd1ltNHdVWURpTWNGZ3ZBSWFyUGdQMWNZ?=
 =?utf-8?B?QUxacFpqbkVoVWpiZjNzM0FrTWVNUXRBZ0VvZ3RCRjV1c2tMbHZaQ0dpSFRD?=
 =?utf-8?B?d3BlY0wySnhmc0RYKzBJVXo2WFdsWi9rTHlQZnEwMmNzMWdnakRWS2NVK0JI?=
 =?utf-8?B?TlhTVHA5TGNaN0pQQzQ3SlhhZ0h4bkF1c3M3cksxMTFCbVcvb2djT21ZcmN0?=
 =?utf-8?B?aHhZcTJUSUthQXB1bzFzVVV4N0k4TnA0Q0RxSmJTOG9wZ1hIZ29iVXJjQlB6?=
 =?utf-8?B?TmVVUUlQSkpiYWVmWU1ES3plcGNXQXB5N1dyVWM0YUVuQnhKUkNOUndUcTdy?=
 =?utf-8?B?UkwydjJUOURnL2JobU9BVDFPdENzRTJZSndtWmtORUxtUVJHRTU1U1IvWE1Z?=
 =?utf-8?B?Y1ExdUo2ZVZXSGo3a0JabFZIamgzUjVTVERIbk01K0FyL1hDazhabkYxaEoz?=
 =?utf-8?B?M0x0QjFMWk5xOGxCQnhSWHlsRnFkSXR6TTI5ME5MbHoycFN0WnRJbnFzeEFs?=
 =?utf-8?B?NEliVG1WMm15OWhWbE8xZW50d2hrMll0N1FaOFhRZUVmYmZQbUdCMWp0emZa?=
 =?utf-8?B?akRYajRQVFRSYmdsUUFvaEl3TUJaVkpaSTYxVGNuZGo0SEhBenNka3cwYW52?=
 =?utf-8?B?QmtOejFHL2VieDY4OGxjRkVFakprTVF1VlU4bHUxRzVjY1d1MkFDRjhYVElo?=
 =?utf-8?B?Q0dlZGpxK3JRQS9IOHY5dWYrWEtPUm54TS9idzdUK3kzRnE4WXRpTjVVZVF3?=
 =?utf-8?B?MnpoRFZKSHZTaldHMkdCd1hqN0ZCdjdFM0RnUGhFdjFtV05PVFZvSFNheGFT?=
 =?utf-8?B?YjJaWFZINTluM25Nd0t6cUlLOXc0Tmw4WVZpQzNheU9IQS9DZStOYklmTURh?=
 =?utf-8?B?bkg4OWd4TmtLK0s3Y0VocHQ5NTE4eHFOOE1kcStkd2pEUVFkWWhaZW91eXpR?=
 =?utf-8?B?NGhuZURIZFZDT2I4Zkg0MWlQVWNLMFpMakEzK1ZlL2xzYnpSQzlWczF0NnA5?=
 =?utf-8?B?emJsbENXL0xUTExYUUpZbU9xN2tzaGtpTUxNYWRtUitjcUZFeXZQTnFTR1RM?=
 =?utf-8?B?SGNqcFRVNHhXU0o5R1pYV0VqM2N0aHFBSGdVckxPYUJ2UEQ3cE9lYWpsM2M0?=
 =?utf-8?B?S2puQXdEaXRsQmdpYWRZT0JRN3E0MG5jbDF5THg1ZTZrTEQvM0FhaGZtTTFZ?=
 =?utf-8?B?MWFVY05HNGJXT21ySWtJMGhZOEY2VDVRbjNzZjQ2UStMVzFmOVYyem5OK1N6?=
 =?utf-8?B?Y1JSSHZQSUxRV1FXTUZ1RGhpWktxVmJUSjYrUWhlQmxFaUNoREJhZThYQXo3?=
 =?utf-8?B?a25iSG12a3JjZXpNamlYbE16R2FmQXFWNUdLOGVjOHpmYnhobG5OT0QveGVt?=
 =?utf-8?B?cUEycUNnRG93blZYaTZ3ZUJkTmp1ZDhxYVdqUWY5L01lZFhLdHNGTDZFczJE?=
 =?utf-8?B?Q2lpNmtOT3hlWHhUdEZwVkN3bUd0R1grVEZWK1R1U1B3ODJLTHNIcE4wMDZC?=
 =?utf-8?B?YzdHQ2Z2SHk3QUY4QUFCQS9WTDVJbGFzdGowcEUzai9QYW95L2FSd3ZzTUNY?=
 =?utf-8?B?a3NWd0h3MWxINnovSXdadlIxY1BOTUY4R0pTMHlNNWN0ektkbGRtQjFWODlV?=
 =?utf-8?Q?jnYxnkz3BwIjwPde+b+6+qM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2F043B1274170248A52544D955F8ED87@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5819.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 271d3d9b-5bc6-46e8-d46b-08de23a8ab4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2025 18:07:26.8424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RyZh04anbnK0bB1CoDJfz/wdukVZUvR8I7bE8uBQXEXinS+zTKNi4iMcy/F2uIOftd2LLLdivStJCwpITb3j6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR15MB6045
X-Proofpoint-ORIG-GUID: 7FHBSdiYvzAKW74MjctjxZfK9ApKtNsR
X-Authority-Analysis: v=2.4 cv=E9nAZKdl c=1 sm=1 tr=0 ts=69176fe3 cx=c_pps
 a=WlOtikQjNqa04qC7x4SRFg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=EbUUtCcH-d1_W62sAucA:9 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEzMDE3OSBTYWx0ZWRfX3G7+x17lagPI
 mf0/2jZmHfD0YdiVAhPlncuXb6SYyPPw5re9WLqFFeK23EQhbekAaBzGvYoNoKoZfHaJjbE/L5i
 MXVh1zsN4qs9CGv+JQw4g5A/0ZOTv7RA+JW9k7vHzDbSEMQrbb+y33NAZ4aI5i2YQBXw4JlPplN
 iKHyaAdtJB1+iHGIJNfMtfBNVoI0tIs68wQGn6U69Lfocd2Ty+TuK2zJRUtw8c6chVhZyL7YXO0
 EkNHOIvEZECH8SV3MOK1IOyEc+/Rr7dLZK4+k3QHSxHbwXXZZ4uo43xdfAHYndUiO51D2/BCHQU
 3x7GWG3Pj5cp4RoAiPxkktXSVOdmMmmt5QXTv70yqvf/3PIrOoYg4l3o+Fw82sHk/arptX9JQMs
 fLvv/rkzx//y/KvkaOCrEfDR8cG+yQ==
X-Proofpoint-GUID: JjULXMR2zMHOHcsGj1xTglXUibiK3CgU
Subject: Re:  [PATCH v5 6/6] ceph: replace local base64 helpers with
 lib/base64
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-14_05,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 impostorscore=0 malwarescore=0 clxscore=1011
 priorityscore=1501 adultscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511130179

T24gRnJpLCAyMDI1LTExLTE0IGF0IDE0OjAyICswODAwLCBHdWFuLUNodW4gV3Ugd3JvdGU6DQo+
IFJlbW92ZSB0aGUgY2VwaF9iYXNlNjRfZW5jb2RlKCkgYW5kIGNlcGhfYmFzZTY0X2RlY29kZSgp
IGZ1bmN0aW9ucyBhbmQNCj4gcmVwbGFjZSB0aGVpciB1c2FnZSB3aXRoIHRoZSBnZW5lcmljIGJh
c2U2NF9lbmNvZGUoKSBhbmQgYmFzZTY0X2RlY29kZSgpDQo+IGhlbHBlcnMgZnJvbSBsaWIvYmFz
ZTY0Lg0KPiANCj4gVGhpcyBlbGltaW5hdGVzIHRoZSBjdXN0b20gaW1wbGVtZW50YXRpb24gaW4g
Q2VwaCwgcmVkdWNlcyBjb2RlDQo+IGR1cGxpY2F0aW9uLCBhbmQgcmVsaWVzIG9uIHRoZSBzaGFy
ZWQgQmFzZTY0IGNvZGUgaW4gbGliLg0KPiBUaGUgaGVscGVycyBwcmVzZXJ2ZSBSRkMgMzUwMS1j
b21wbGlhbnQgQmFzZTY0IGVuY29kaW5nIHdpdGhvdXQgcGFkZGluZywNCj4gc28gdGhlcmUgYXJl
IG5vIGZ1bmN0aW9uYWwgY2hhbmdlcy4NCj4gDQo+IFRoaXMgY2hhbmdlIGFsc28gaW1wcm92ZXMg
cGVyZm9ybWFuY2U6IGVuY29kaW5nIGlzIGFib3V0IDIuN3ggZmFzdGVyIGFuZA0KPiBkZWNvZGlu
ZyBhY2hpZXZlcyA0My01Mnggc3BlZWR1cHMgY29tcGFyZWQgdG8gdGhlIHByZXZpb3VzIGxvY2Fs
DQo+IGltcGxlbWVudGF0aW9uLg0KPiANCj4gUmV2aWV3ZWQtYnk6IEt1YW4tV2VpIENoaXUgPHZp
c2l0b3Jja3dAZ21haWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBHdWFuLUNodW4gV3UgPDQwOTQx
MTcxNkBnbXMudGt1LmVkdS50dz4NCj4gLS0tDQo+ICBmcy9jZXBoL2NyeXB0by5jIHwgNjAgKysr
Ky0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICBmcy9jZXBo
L2NyeXB0by5oIHwgIDYgKy0tLS0NCj4gIGZzL2NlcGgvZGlyLmMgICAgfCAgNSArKy0tDQo+ICBm
cy9jZXBoL2lub2RlLmMgIHwgIDIgKy0NCj4gIDQgZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25z
KCspLCA2NCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2NyeXB0by5j
IGIvZnMvY2VwaC9jcnlwdG8uYw0KPiBpbmRleCA3MDI2ZTc5NDgxM2MuLmI2MDE2ZGNmZmJiNiAx
MDA2NDQNCj4gLS0tIGEvZnMvY2VwaC9jcnlwdG8uYw0KPiArKysgYi9mcy9jZXBoL2NyeXB0by5j
DQo+IEBAIC0xNSw1OSArMTUsNiBAQA0KPiAgI2luY2x1ZGUgIm1kc19jbGllbnQuaCINCj4gICNp
bmNsdWRlICJjcnlwdG8uaCINCj4gIA0KPiAtLyoNCj4gLSAqIFRoZSBiYXNlNjR1cmwgZW5jb2Rp
bmcgdXNlZCBieSBmc2NyeXB0IGluY2x1ZGVzIHRoZSAnXycgY2hhcmFjdGVyLCB3aGljaCBtYXkN
Cj4gLSAqIGNhdXNlIHByb2JsZW1zIGluIHNuYXBzaG90IG5hbWVzICh3aGljaCBjYW4gbm90IHN0
YXJ0IHdpdGggJ18nKS4gIFRodXMsIHdlDQo+IC0gKiB1c2VkIHRoZSBiYXNlNjQgZW5jb2Rpbmcg
ZGVmaW5lZCBmb3IgSU1BUCBtYWlsYm94IG5hbWVzIChSRkMgMzUwMSkgaW5zdGVhZCwNCj4gLSAq
IHdoaWNoIHJlcGxhY2VzICctJyBhbmQgJ18nIGJ5ICcrJyBhbmQgJywnLg0KPiAtICovDQo+IC1z
dGF0aWMgY29uc3QgY2hhciBiYXNlNjRfdGFibGVbNjVdID0NCj4gLQkiQUJDREVGR0hJSktMTU5P
UFFSU1RVVldYWVphYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ejAxMjM0NTY3ODkrLCI7DQo+IC0N
Cj4gLWludCBjZXBoX2Jhc2U2NF9lbmNvZGUoY29uc3QgdTggKnNyYywgaW50IHNyY2xlbiwgY2hh
ciAqZHN0KQ0KPiAtew0KPiAtCXUzMiBhYyA9IDA7DQo+IC0JaW50IGJpdHMgPSAwOw0KPiAtCWlu
dCBpOw0KPiAtCWNoYXIgKmNwID0gZHN0Ow0KPiAtDQo+IC0JZm9yIChpID0gMDsgaSA8IHNyY2xl
bjsgaSsrKSB7DQo+IC0JCWFjID0gKGFjIDw8IDgpIHwgc3JjW2ldOw0KPiAtCQliaXRzICs9IDg7
DQo+IC0JCWRvIHsNCj4gLQkJCWJpdHMgLT0gNjsNCj4gLQkJCSpjcCsrID0gYmFzZTY0X3RhYmxl
WyhhYyA+PiBiaXRzKSAmIDB4M2ZdOw0KPiAtCQl9IHdoaWxlIChiaXRzID49IDYpOw0KPiAtCX0N
Cj4gLQlpZiAoYml0cykNCj4gLQkJKmNwKysgPSBiYXNlNjRfdGFibGVbKGFjIDw8ICg2IC0gYml0
cykpICYgMHgzZl07DQo+IC0JcmV0dXJuIGNwIC0gZHN0Ow0KPiAtfQ0KPiAtDQo+IC1pbnQgY2Vw
aF9iYXNlNjRfZGVjb2RlKGNvbnN0IGNoYXIgKnNyYywgaW50IHNyY2xlbiwgdTggKmRzdCkNCj4g
LXsNCj4gLQl1MzIgYWMgPSAwOw0KPiAtCWludCBiaXRzID0gMDsNCj4gLQlpbnQgaTsNCj4gLQl1
OCAqYnAgPSBkc3Q7DQo+IC0NCj4gLQlmb3IgKGkgPSAwOyBpIDwgc3JjbGVuOyBpKyspIHsNCj4g
LQkJY29uc3QgY2hhciAqcCA9IHN0cmNocihiYXNlNjRfdGFibGUsIHNyY1tpXSk7DQo+IC0NCj4g
LQkJaWYgKHAgPT0gTlVMTCB8fCBzcmNbaV0gPT0gMCkNCj4gLQkJCXJldHVybiAtMTsNCj4gLQkJ
YWMgPSAoYWMgPDwgNikgfCAocCAtIGJhc2U2NF90YWJsZSk7DQo+IC0JCWJpdHMgKz0gNjsNCj4g
LQkJaWYgKGJpdHMgPj0gOCkgew0KPiAtCQkJYml0cyAtPSA4Ow0KPiAtCQkJKmJwKysgPSAodTgp
KGFjID4+IGJpdHMpOw0KPiAtCQl9DQo+IC0JfQ0KPiAtCWlmIChhYyAmICgoMSA8PCBiaXRzKSAt
IDEpKQ0KPiAtCQlyZXR1cm4gLTE7DQo+IC0JcmV0dXJuIGJwIC0gZHN0Ow0KPiAtfQ0KPiAtDQo+
ICBzdGF0aWMgaW50IGNlcGhfY3J5cHRfZ2V0X2NvbnRleHQoc3RydWN0IGlub2RlICppbm9kZSwg
dm9pZCAqY3R4LCBzaXplX3QgbGVuKQ0KPiAgew0KPiAgCXN0cnVjdCBjZXBoX2lub2RlX2luZm8g
KmNpID0gY2VwaF9pbm9kZShpbm9kZSk7DQo+IEBAIC0zMTgsNyArMjY1LDcgQEAgaW50IGNlcGhf
ZW5jb2RlX2VuY3J5cHRlZF9kbmFtZShzdHJ1Y3QgaW5vZGUgKnBhcmVudCwgY2hhciAqYnVmLCBp
bnQgZWxlbikNCj4gIAl9DQo+ICANCj4gIAkvKiBiYXNlNjQgZW5jb2RlIHRoZSBlbmNyeXB0ZWQg
bmFtZSAqLw0KPiAtCWVsZW4gPSBjZXBoX2Jhc2U2NF9lbmNvZGUoY3J5cHRidWYsIGxlbiwgcCk7
DQo+ICsJZWxlbiA9IGJhc2U2NF9lbmNvZGUoY3J5cHRidWYsIGxlbiwgcCwgZmFsc2UsIEJBU0U2
NF9JTUFQKTsNCj4gIAlkb3V0YyhjbCwgImJhc2U2NC1lbmNvZGVkIGNpcGhlcnRleHQgbmFtZSA9
ICUuKnNcbiIsIGVsZW4sIHApOw0KPiAgDQo+ICAJLyogVG8gdW5kZXJzdGFuZCB0aGUgMjQwIGxp
bWl0LCBzZWUgQ0VQSF9OT0hBU0hfTkFNRV9NQVggY29tbWVudHMgKi8NCj4gQEAgLTQxMiw3ICsz
NTksOCBAQCBpbnQgY2VwaF9mbmFtZV90b191c3IoY29uc3Qgc3RydWN0IGNlcGhfZm5hbWUgKmZu
YW1lLCBzdHJ1Y3QgZnNjcnlwdF9zdHIgKnRuYW1lLA0KPiAgCQkJdG5hbWUgPSAmX3RuYW1lOw0K
PiAgCQl9DQo+ICANCj4gLQkJZGVjbGVuID0gY2VwaF9iYXNlNjRfZGVjb2RlKG5hbWUsIG5hbWVf
bGVuLCB0bmFtZS0+bmFtZSk7DQo+ICsJCWRlY2xlbiA9IGJhc2U2NF9kZWNvZGUobmFtZSwgbmFt
ZV9sZW4sDQo+ICsJCQkJICAgICAgIHRuYW1lLT5uYW1lLCBmYWxzZSwgQkFTRTY0X0lNQVApOw0K
PiAgCQlpZiAoZGVjbGVuIDw9IDApIHsNCj4gIAkJCXJldCA9IC1FSU87DQo+ICAJCQlnb3RvIG91
dDsNCj4gQEAgLTQyNiw3ICszNzQsNyBAQCBpbnQgY2VwaF9mbmFtZV90b191c3IoY29uc3Qgc3Ry
dWN0IGNlcGhfZm5hbWUgKmZuYW1lLCBzdHJ1Y3QgZnNjcnlwdF9zdHIgKnRuYW1lLA0KPiAgDQo+
ICAJcmV0ID0gZnNjcnlwdF9mbmFtZV9kaXNrX3RvX3VzcihkaXIsIDAsIDAsICZpbmFtZSwgb25h
bWUpOw0KPiAgCWlmICghcmV0ICYmIChkaXIgIT0gZm5hbWUtPmRpcikpIHsNCj4gLQkJY2hhciB0
bXBfYnVmW0NFUEhfQkFTRTY0X0NIQVJTKE5BTUVfTUFYKV07DQo+ICsJCWNoYXIgdG1wX2J1ZltC
QVNFNjRfQ0hBUlMoTkFNRV9NQVgpXTsNCj4gIA0KPiAgCQluYW1lX2xlbiA9IHNucHJpbnRmKHRt
cF9idWYsIHNpemVvZih0bXBfYnVmKSwgIl8lLipzXyVsZCIsDQo+ICAJCQkJICAgIG9uYW1lLT5s
ZW4sIG9uYW1lLT5uYW1lLCBkaXItPmlfaW5vKTsNCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvY3J5
cHRvLmggYi9mcy9jZXBoL2NyeXB0by5oDQo+IGluZGV4IDIzNjEyYjJlOTgzNy4uYjc0OGUyMDYw
YmM5IDEwMDY0NA0KPiAtLS0gYS9mcy9jZXBoL2NyeXB0by5oDQo+ICsrKyBiL2ZzL2NlcGgvY3J5
cHRvLmgNCj4gQEAgLTgsNiArOCw3IEBADQo+ICANCj4gICNpbmNsdWRlIDxjcnlwdG8vc2hhMi5o
Pg0KPiAgI2luY2x1ZGUgPGxpbnV4L2ZzY3J5cHQuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9iYXNl
NjQuaD4NCj4gIA0KPiAgI2RlZmluZSBDRVBIX0ZTQ1JZUFRfQkxPQ0tfU0hJRlQgICAxMg0KPiAg
I2RlZmluZSBDRVBIX0ZTQ1JZUFRfQkxPQ0tfU0laRSAgICAoX0FDKDEsIFVMKSA8PCBDRVBIX0ZT
Q1JZUFRfQkxPQ0tfU0hJRlQpDQo+IEBAIC04OSwxMSArOTAsNiBAQCBzdGF0aWMgaW5saW5lIHUz
MiBjZXBoX2ZzY3J5cHRfYXV0aF9sZW4oc3RydWN0IGNlcGhfZnNjcnlwdF9hdXRoICpmYSkNCj4g
ICAqLw0KPiAgI2RlZmluZSBDRVBIX05PSEFTSF9OQU1FX01BWCAoMTgwIC0gU0hBMjU2X0RJR0VT
VF9TSVpFKQ0KPiAgDQo+IC0jZGVmaW5lIENFUEhfQkFTRTY0X0NIQVJTKG5ieXRlcykgRElWX1JP
VU5EX1VQKChuYnl0ZXMpICogNCwgMykNCj4gLQ0KPiAtaW50IGNlcGhfYmFzZTY0X2VuY29kZShj
b25zdCB1OCAqc3JjLCBpbnQgc3JjbGVuLCBjaGFyICpkc3QpOw0KPiAtaW50IGNlcGhfYmFzZTY0
X2RlY29kZShjb25zdCBjaGFyICpzcmMsIGludCBzcmNsZW4sIHU4ICpkc3QpOw0KPiAtDQo+ICB2
b2lkIGNlcGhfZnNjcnlwdF9zZXRfb3BzKHN0cnVjdCBzdXBlcl9ibG9jayAqc2IpOw0KPiAgDQo+
ICB2b2lkIGNlcGhfZnNjcnlwdF9mcmVlX2R1bW15X3BvbGljeShzdHJ1Y3QgY2VwaF9mc19jbGll
bnQgKmZzYyk7DQo+IGRpZmYgLS1naXQgYS9mcy9jZXBoL2Rpci5jIGIvZnMvY2VwaC9kaXIuYw0K
PiBpbmRleCBkMThjMGVhZWY5YjcuLjBmYTdjNzc3NzI0MiAxMDA2NDQNCj4gLS0tIGEvZnMvY2Vw
aC9kaXIuYw0KPiArKysgYi9mcy9jZXBoL2Rpci5jDQo+IEBAIC05OTgsMTMgKzk5OCwxNCBAQCBz
dGF0aWMgaW50IHByZXBfZW5jcnlwdGVkX3N5bWxpbmtfdGFyZ2V0KHN0cnVjdCBjZXBoX21kc19y
ZXF1ZXN0ICpyZXEsDQo+ICAJaWYgKGVycikNCj4gIAkJZ290byBvdXQ7DQo+ICANCj4gLQlyZXEt
PnJfcGF0aDIgPSBrbWFsbG9jKENFUEhfQkFTRTY0X0NIQVJTKG9zZF9saW5rLmxlbikgKyAxLCBH
RlBfS0VSTkVMKTsNCj4gKwlyZXEtPnJfcGF0aDIgPSBrbWFsbG9jKEJBU0U2NF9DSEFSUyhvc2Rf
bGluay5sZW4pICsgMSwgR0ZQX0tFUk5FTCk7DQo+ICAJaWYgKCFyZXEtPnJfcGF0aDIpIHsNCj4g
IAkJZXJyID0gLUVOT01FTTsNCj4gIAkJZ290byBvdXQ7DQo+ICAJfQ0KPiAgDQo+IC0JbGVuID0g
Y2VwaF9iYXNlNjRfZW5jb2RlKG9zZF9saW5rLm5hbWUsIG9zZF9saW5rLmxlbiwgcmVxLT5yX3Bh
dGgyKTsNCj4gKwlsZW4gPSBiYXNlNjRfZW5jb2RlKG9zZF9saW5rLm5hbWUsIG9zZF9saW5rLmxl
biwNCj4gKwkJCSAgICByZXEtPnJfcGF0aDIsIGZhbHNlLCBCQVNFNjRfSU1BUCk7DQo+ICAJcmVx
LT5yX3BhdGgyW2xlbl0gPSAnXDAnOw0KPiAgb3V0Og0KPiAgCWZzY3J5cHRfZm5hbWVfZnJlZV9i
dWZmZXIoJm9zZF9saW5rKTsNCj4gZGlmZiAtLWdpdCBhL2ZzL2NlcGgvaW5vZGUuYyBiL2ZzL2Nl
cGgvaW5vZGUuYw0KPiBpbmRleCBhNmUyNjBkOWU0MjAuLmI2OTEzNDNjYjdmMSAxMDA2NDQNCj4g
LS0tIGEvZnMvY2VwaC9pbm9kZS5jDQo+ICsrKyBiL2ZzL2NlcGgvaW5vZGUuYw0KPiBAQCAtOTU4
LDcgKzk1OCw3IEBAIHN0YXRpYyBpbnQgZGVjb2RlX2VuY3J5cHRlZF9zeW1saW5rKHN0cnVjdCBj
ZXBoX21kc19jbGllbnQgKm1kc2MsDQo+ICAJaWYgKCFzeW0pDQo+ICAJCXJldHVybiAtRU5PTUVN
Ow0KPiAgDQo+IC0JZGVjbGVuID0gY2VwaF9iYXNlNjRfZGVjb2RlKGVuY3N5bSwgZW5jbGVuLCBz
eW0pOw0KPiArCWRlY2xlbiA9IGJhc2U2NF9kZWNvZGUoZW5jc3ltLCBlbmNsZW4sIHN5bSwgZmFs
c2UsIEJBU0U2NF9JTUFQKTsNCj4gIAlpZiAoZGVjbGVuIDwgMCkgew0KPiAgCQlwcl9lcnJfY2xp
ZW50KGNsLA0KPiAgCQkJImNhbid0IGRlY29kZSBzeW1saW5rICglZCkuIENvbnRlbnQ6ICUuKnNc
biIsDQoNCkxvb2tzIGdvb2QhDQoNClJldmlld2VkLWJ5OiBWaWFjaGVzbGF2IER1YmV5a28gPFNs
YXZhLkR1YmV5a29AaWJtLmNvbT4NCg0KSGF2ZSB5b3UgcnVuIHhmc3Rlc3RzIGZvciB0aGlzIHBh
dGNoc2V0Pw0KDQpUaGFua3MsDQpTbGF2YS4NCg==

