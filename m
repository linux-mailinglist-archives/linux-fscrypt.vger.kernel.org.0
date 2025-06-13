Return-Path: <linux-fscrypt+bounces-669-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F1EAD8A0B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 13:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89E2617985B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Jun 2025 11:11:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E14722D5C6C;
	Fri, 13 Jun 2025 11:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZtxBI+Do"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C78F2D4B5D;
	Fri, 13 Jun 2025 11:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749813082; cv=fail; b=qpFS6jSeChZg2joZNp22mO5eqRBjKXqwpUY8riS5b4xRQMtUgqDkIrF98qtg1zVV6Kwz/9GvFGG/BL+HZon/Q28utowKXuNt6JGGEFnX3Vpt9t15+rdVCgAX3KxbYXXT7dUFUBjTR2H3QhohO4LSqkXARsoX5vXn3H/kVlaHSVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749813082; c=relaxed/simple;
	bh=l6E6nmJnWscDwtYON7NmvKEMEnam+0no3YBdvlIcDoo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WSba1qVxyLpohs1giUyVXQiAQtODYcxAt/eaewZ5rQxBIoFEbpd5DkyobukDDLziLnU1EkcDmk8wzTpPznegGxpbMwwp6/1KhLYCf1Xjj86//geCjSmgkplj/YidGc/z4L2lUP1uBx5Cqi/tXRVRNQF6YYI0tqZpk5ypm7KB7Ro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZtxBI+Do; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749813081; x=1781349081;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=l6E6nmJnWscDwtYON7NmvKEMEnam+0no3YBdvlIcDoo=;
  b=ZtxBI+Dop0/G69GoUzdXHTULvGytiEzJ9MEssj8wzB4CvozayIVN/BLC
   46mTRGlNfniWyTr2m9xUWz6sk1m/t4rs/IAvSts/dY9PuCAQbTbV4ahjH
   1BodN0rWRlnE8rZELknevqqA1+kufyoT00w9+Y1rKO+nUfe6fvItUvZg7
   sas6XXDIgEL+pxcCQAa9sJYn1ZeNCEtxgrj2J2XDuLYjJ2cpRLGb06J2A
   7fMSL3UAT12TywY4ODZEHSEvmuJHdPMXI+plYzqTeNdqYBxFQIRjLjvfn
   Hgedb0FCqpUfU76vfPZruDyDrtynr9MAtbH+nHExflMBid3E8+LXTLOAW
   A==;
X-CSE-ConnectionGUID: l39ogO71TBGu2zaRSheQjw==
X-CSE-MsgGUID: mCMaDUzmQROjxgMNIxm80Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="63434779"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="63434779"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 04:11:20 -0700
X-CSE-ConnectionGUID: w7p/Y9DeSmideVQYZABwhQ==
X-CSE-MsgGUID: SNlZxnCOTs2L734RXY1LmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="151625404"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 04:11:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 04:11:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 04:11:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 04:11:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ACbA7PJQn7cuhFBMPeqDUNdL/RxbCR0QcIMT9s/aNfg5DTllFIiSMCyy/jB0s/lxCCtt+jwouxXx4z5YzqvWHgzsn4OGh7z2IhQJduUqRfEqHn1lJoFQG4BS2yqqgOsvS8yh79I4lYxbRxZNW7YWqKFzttVCAHDVpafqpPDHSdb6E/VCu9qZC3wLQOIY7F1fpTBYiuB9uvqIF27Ine45FxSQ4g+bvtJQk34SyAagaQigVIGX3x/PCzqv3lFIpuvjTTJNAclV1M6aBEwwx4AlrCbNEv42CCRADSgtoEnzdWYkWRULeuvCFekK/DGARA9C6tOJoxuaI3WNo4xtE1l6AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/Cx+f8rTVJR7E9rFHuhqwRyqcTrLEplvZQgJimvF8k=;
 b=wDflSDIBirHQtpK4Y2f3xSPIHmbOiLX5VZ6Y9mwKHs+klUtupnvQQ7U5g5STk3LBsGaGKPSIE1DKuGtyBPlzTKeweZbX3KVBDCGu2WWpodcMGy12JhzEFRieGUg/WxJwPSZBT++Bdcs0ElDaZTVOcsJ94AKC49PoWtYWuhJcdawno2OlK9QP9J5ZPHEUl3dpKQpHcG+zshcHRG1rtvjXDY/dO/EwbjyeerslH2YkEsVA5/i2g8QVeXmVA+HweJ9IU0Z/wOqIQwHyjE39akkIb52Pd99J5KmkEF+ZwaBSyq7jCIxSV3jwEPd2ilI2Iv+B7ipG5BPla/WA1fwDGTSzUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by CH3PR11MB8187.namprd11.prod.outlook.com (2603:10b6:610:160::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Fri, 13 Jun
 2025 11:11:02 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8835.019; Fri, 13 Jun 2025
 11:11:02 +0000
Date: Fri, 13 Jun 2025 12:10:54 +0100
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: Eric Biggers <ebiggers@kernel.org>
CC: Simon Richter <Simon.Richter@hogyros.de>, <linux-fscrypt@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mtd@lists.infradead.org>, <linux-ext4@vger.kernel.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <ceph-devel@vger.kernel.org>
Subject: Re: [PATCH] fscrypt: don't use hardware offload Crypto API drivers
Message-ID: <aEwHPjxw4K6t5mgf@gcabiddu-mobl.ger.corp.intel.com>
References: <20250611205859.80819-1-ebiggers@kernel.org>
 <7f63be76-289b-4a99-b802-afd72e0512b8@hogyros.de>
 <20250612005914.GA546455@google.com>
 <20250612062521.GA1838@sol>
 <aEqU0iU1tBrLEYUq@gcabiddu-mobl.ger.corp.intel.com>
 <20250612155743.GA3529549@google.com>
 <20250613012357.GA3603104@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250613012357.GA3603104@google.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DUZPR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:46a::11) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|CH3PR11MB8187:EE_
X-MS-Office365-Filtering-Correlation-Id: 93e51119-4945-4527-b9b7-08ddaa6afb78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RIBXQRQs7G5vfjTuvYdovZpurMsryspUzteje9Acsd228kS5FrH0Nk+OwAoL?=
 =?us-ascii?Q?lOGpVYArJSlMBUAswjqJe8k1m46JSuY1lHsw4iB0jjZWOOYwmTEs73U7WvAQ?=
 =?us-ascii?Q?xsZlb51LHXfnpK3BTOp3GESnJIHMj2gbXOkB1Z1G3lOZRzYdaDbV2ldXaVeV?=
 =?us-ascii?Q?1UK9Ql9MzNpB/m6Tl7s86vXFF6p4bWbxp7szHRMn0KXkC6fHdGIDpUhNpVH2?=
 =?us-ascii?Q?WvcLdjhI3d9KSD94BdqFgZpyqypRPqzgMgwj5OSbORqcNUBAtLzfR7GMmpZR?=
 =?us-ascii?Q?khiow99Ycb0OsySU+7oqE4jUSoifCB+AhWpda+Rncr2FRJIV2tzNjvXiotyL?=
 =?us-ascii?Q?NY8k1QgzI5N8Fg34r5bGJkyiFeBfQdXV56Xjkz+4TSDnxLScV4DdRqEZGWCa?=
 =?us-ascii?Q?BPpB9h9Txw8lxE0Yj7ViM2/7L9jmuvFiXFSZTDTyrd5GFZikyd6RMfcq2YAC?=
 =?us-ascii?Q?By7rAPxvbZPiY6Ftn3dTLi36w4qBnj/Nk52wnlZ4eirPqqpOknI4m7kFpHPx?=
 =?us-ascii?Q?B525FAMNwJeUu7r7Ur+dVwuxIbcUkWPJ9HSwb7wt+xnYBEeiw5ietI+ItoLj?=
 =?us-ascii?Q?V5YjSMKN8+n8oGK1WSxYCFc2y26i58BCFH2n3SjVJQcM2SUtQrQ/xeRMuz0a?=
 =?us-ascii?Q?J1wqhiircPSWHVDvmG/T7h60ob1yIhNrJoPowWWoCvsM8/RVAcLkZNGIJhPF?=
 =?us-ascii?Q?DyMrMHW66XA80V4Mo078gHy3RokY4knIIc/fyrEKpKv27vveIWfGzL81jLc/?=
 =?us-ascii?Q?eqg7o1fhiNRZvzgQrhvGrfgphhOTFi/Q5jwY0N4JeXBcuO9zKWb1JPE2n4XE?=
 =?us-ascii?Q?JHss0ws15jGVaAM5FAXIi+NdSMuVenbFqCtJFnmDYq4LP9h8EXIwR4t50606?=
 =?us-ascii?Q?k81Ddm/DdwNUKhRKr7Gr80ZFmWO/MN1BvXasFJGtuQqn6YIeIiSmHGd/4y+D?=
 =?us-ascii?Q?XZ/8RhMlnccgd4eZiQbY64iofEpNo5jUS6Hld26VGWeLqflo8Epkqb9a6mDJ?=
 =?us-ascii?Q?PULem7ad0iJXrF1Rii/lzlMpdi/Ftm7edyUg+OO5nOXOgCFsH8pumABr4Zp5?=
 =?us-ascii?Q?DLVVcDirtUCHhL/dbH8hTrpctgezXYTPSshC1XkTm4xhMFLpsxPbtGufCYkF?=
 =?us-ascii?Q?ygCdlLCnL9tjQaZNZVvzqFBLQvNvjWO6Jdy11ioLFYwqRH3MkiGb5j/FIaCO?=
 =?us-ascii?Q?r1Ofo9/lk8xeLcQHrIp7lLIkMKFMs0mtugLrYRdiI3yp3Awtm4Kbi6TIoMXr?=
 =?us-ascii?Q?Wui94CpvXZfEkhLFtIszzSgRm+bCwLplQFlyxDXVWNbq7EtSNeaSYdEG0vil?=
 =?us-ascii?Q?VT/UklxOTOB26TYf5dr2sTHiKvhpjmICDdMj1iDio1gfg8XQI+DVS5M6VynP?=
 =?us-ascii?Q?QBOGhYiGEKBlIeg0u6efHuavwI8n?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dfD3g7ZtZREHAAxZbsnboNc+C0VK4eZx7MbMWbBB0FE2uzDjqw+PyC4n0/vk?=
 =?us-ascii?Q?JY1qDhRY1rU/jLcKChn8k+EQCAqnBn4orhzbpZk+iYmFG9TFNJ2bVi2b4G5X?=
 =?us-ascii?Q?X36ov5+BBkD0KymgqcWWTmFC0xXrSsAvWfagTMYgJZh0pVjD5RYF8YneV9+O?=
 =?us-ascii?Q?cvQ2p6CtTUOTEuDAKbw8ohjLup9M744xJL3F01qVcXapVrK3SqCrByxfA2CW?=
 =?us-ascii?Q?OOWw36GYj0u2GrgwBOwHgMrxAOf+saUibnaYcYkafolOw9w0LJSR2sbjbHPZ?=
 =?us-ascii?Q?PVuXK8AkN5O/CkvCAiXocBJZmtqxv3xnlCf1sc03LSeuvlrRnINEVHL8gvu9?=
 =?us-ascii?Q?p3ffTdyqJx+esNrvW4vUNYBiwt6LWB0Qbp0a5cxLavKu7T5Iz/pVQXogSN2c?=
 =?us-ascii?Q?U72GzeNY1XM2PqWIuSs5fiazrT+7nI7Oan+0vfFmrucaKKD2dTfzvpg+Ws2L?=
 =?us-ascii?Q?1VBV8IWhDKdQuC2BMzvNJEI++hUbf63mC+L5VinR0dC/jzd/bmjcXrsMK2Qi?=
 =?us-ascii?Q?IL4kDPODnOI/fTzekFHwFJjFdutVUi3l65iSyImkuaiwbeZbpOsRAW4wX575?=
 =?us-ascii?Q?08ZpGCbfqnoCmOnF+34G5h2tlB/GIJMIRv/lyFSDC/c00Wu9q076mmErvyfA?=
 =?us-ascii?Q?uAM5A68hYj925nxRWz/3LgmS7uV674kKbgkI6FDkCdQd/vi/30m5GU6CF38H?=
 =?us-ascii?Q?fZaZIo7kCYzyONDCPFxYNaFzuo8ZBquowJsSKkgyYpkSIU2m8NF/AUnK9I6I?=
 =?us-ascii?Q?eJ4KjUE+r5izqwqYTSXs5NJyIi0PQYiPNt5hBstBoxtMkX0d0rmBcyram02i?=
 =?us-ascii?Q?Loe84CbLZHahc1JAGH04tQh0DdBr0WZeyvuQqmxv7wEzhpd/bkDvbMHRz0eo?=
 =?us-ascii?Q?k4aFgvzpW8chqa+vGyzkeAfjva0ZhwZmfeI7p5RD0N+FsAFakf5HZT07nuYz?=
 =?us-ascii?Q?BIqc7sDvkxbx4T0JuF6bnq46o/GcNefUVBp/d2WyXgspF7X+7n9cFVheUqBx?=
 =?us-ascii?Q?w+6xHyC8h+d5k8adOHYzX7PXrSh7ueklJX3xjgMUMEIOGkOEYYb7pfdwMg4u?=
 =?us-ascii?Q?RIR9VzZIqTFy676kW6DCQyuUK956/nKj3S6Qw5NXVjdgqGutyY4jp0OTGeW7?=
 =?us-ascii?Q?EIJM8k/GRTLU3NalgH7a09fEA03OR+ubo3wRH2rOpxP4WxAesjuqjGfVUVF5?=
 =?us-ascii?Q?a+Cs3TGLPZdCIrQeSoGRFTkWVBm0nth0FBvClB6DWON/iLHSRq1tuC5/VSPd?=
 =?us-ascii?Q?SgT0iqznOKU9tCi46gtsdWMFigQYnZYXULDUO7Enb3PNbHY3cTQynADIscb3?=
 =?us-ascii?Q?966d/Ygu4nTylDDkbYGLZrhnI8174aVD4g4yDed4xMzBRUVeIY4Ef2DMRC4z?=
 =?us-ascii?Q?g8R94o0Iv47sBY5A4287bAqvYMLUHlXAvR8FPUTjO099BoZxb3x7r0ILykv4?=
 =?us-ascii?Q?OgVUg2pVY9vYt+UjH+HUqd20SKZ2uykBAM9bzwz6CWR1tEdaEuOXAdO85DXD?=
 =?us-ascii?Q?hACam7+rRI1EmHomQShSO8WAsi2xlk9FzX8ujd2t4hWx9cEiGL7ENVRm+2eC?=
 =?us-ascii?Q?dLRNHgqOVGXJ1XH79ToAvYvzEMX9XPgpkVP6TtzER5n4M0KIx89awvMu5RUr?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 93e51119-4945-4527-b9b7-08ddaa6afb78
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 11:11:02.0308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oL9yadlFGCe9eiuPWfqtQy5Oe1kxZDIckPk6V51PoICCK5eppG2vY1zqRQWrYbRxbvZ9ot4xmf56k9TZ6qEMXFVeFR5z8I+93HiFHtNlmPk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8187
X-OriginatorOrg: intel.com

On Fri, Jun 13, 2025 at 01:23:57AM +0000, Eric Biggers wrote:
> On Thu, Jun 12, 2025 at 03:57:43PM +0000, Eric Biggers wrote:
> > On Thu, Jun 12, 2025 at 09:50:26AM +0100, Giovanni Cabiddu wrote:
> > > On Wed, Jun 11, 2025 at 11:25:21PM -0700, Eric Biggers wrote:
> > > 
> > > ...
> > > 
> > > > FWIW, here's what happens if you try to use the Intel QAT driver with dm-crypt:
> > > > https://lore.kernel.org/r/CACsaVZ+mt3CfdXV0_yJh7d50tRcGcRZ12j3n6-hoX2cz3+njsg@mail.gmail.com/
> > > 
> > > /s/happens/happened/
> > > 
> > > ... and it got fixed
> > > https://lore.kernel.org/all/20220506082327.21605-1-giovanni.cabiddu@intel.com/
> > 
> > But it reached users in the first place, including stable kernels.  And
> > apparently the issues were going on for years and were known to the authors of
> > the driver
> > (https://lore.kernel.org/linux-crypto/91fe9f87-54d7-4140-4d1a-eac8e2081a7c@gmail.com/).
> > 
> > We simply don't have issues like this with the AES-NI or VAES XTS code.
> > 
> > And separately, QAT was reported to be much slower than AES-NI for synchronous use
> > (https://lore.kernel.org/linux-crypto/0171515-7267-624-5a22-238af829698f@redhat.com/)
> > 
> > Later, I added VAES accelerated AES-XTS code which is over twice as fast as
> > AES-NI on the latest Intel CPUs, so that likely widened the gap even more.
> > 
> > Yet, the QAT driver registers its "xts(aes)" implementation with priority 4001,
> > compared to priority 800 for the VAES accelerated one.  So the QAT one is the
> > one that will be used by fscrypt!
> > 
> > That seems like a major issue even just from a performance perspective.
> > 
> > I expect this patch will significantly improve fscrypt performance on Intel
> > servers that have QAT.
> 
> I was curious, so I actually ran a benchmark on an Intel Emerald Rapids server.
> Specifically, I used a kernel module that repeatedly en/decrypted 4096-byte
> messages with AES-XTS using crypto_skcipher_en/decrypt().  That's basically what
> fscrypt's file contents encryption does, but here I just measured the raw crypto
> performance.  I tested both xts-aes-vaes-avx512 and qat_aes_xts.  For both, the
> difference between encryption and decryption was within the margin of error, so
> I'll give just one number for each.
> 
> Results:
> 
>     xts-aes-vaes-avx512: 16171 MB/s
>     qat_aes_xts: 289 MB/s
> 
> So, QAT is 55 times slower than the VAES-optimized software code!
> 
> It's even slower than the generic C code:
>      
>     xts(ecb(aes-generic)): 305 MB/s
> 
> Now, it could be argued that this is user error -- I "should" have created lots
> of asynchronous crypto requests for 4K blocks, submitted them all at once, and
> waited for them to complete.  Thus allowing parallel processing by QAT.
> 
> But, that's simply not what fscrypt does.  And even if it did, it could only
> plausibly help for large bios.  Short bios, for which latency is really
> important, would continue to be massively regressed by using QAT for them.
> 
> Even for large bios, it would have to get over 55 times faster to be worth it,
> which seems (very?) tenuous.
> 
> Also, as is known from dm-crypt which does do async processing, the code that's
> needed to do it is quite complex and error-prone.
> 
> In any case, async processing would be a theoretical future improvement.  It's
> simply not what fscrypt does today, or has ever done.
> 
> I also found that, even though I built the QAT driver as a loadable module, it
> was loaded automatically on the system and prioritized itself over the VAES-
> accelerated AES-XTS.  Thus, it would be what fscrypt uses on Intel servers where
> the QAT driver is enabled in kconfig, even just as 'm'.
I just sent a patch to lower the priority of the skcipher (and aead)
algorithms in the QAT driver. This should allow xts-aes-vaes-avx512 to be
selected by default.

As for the module loading behaviour: loadable modules are automatically
loaded at startup if hardware that matches the device IDs they support
is found.

Regards,

-- 
Giovanni

