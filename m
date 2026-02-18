Return-Path: <linux-fscrypt+bounces-1155-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8EzrIsrflWneVgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1155-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:50:34 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28FCA1577DA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 16:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8CBF53005A96
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Feb 2026 15:50:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD79A340A59;
	Wed, 18 Feb 2026 15:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Ju8WL1n9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF892F7445;
	Wed, 18 Feb 2026 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.145.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771429831; cv=fail; b=li4FGKOFy4bto8uHXVEiBAWNG+ycKbCH/oIIZpRaDaIjMK/c4SdZV4rfNmNC8oqDQoTYbxygtG1oKSeKud7Ph2FI6JLqo8EDvevnyVBxQ3xlZRZ9xdaR8EnDZmIEEd68IWMehAjH5SIaqJ/5jiJMRpCEYau02StXS8lC9QvcDS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771429831; c=relaxed/simple;
	bh=iw2iS/BtdcPZgi7EJQ/BIpAR0B+5wuu5MAsh0xTPD6c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eXUJqtCnpSmTZ5k5m33F0FNBbAf5/ZGEE9TosUGmHYZAgHU01zAxKXfxuFKH4Ao3yjuXespAguyrqJonaTBFmlUlX6C5UmwhDXn3YgkUf6/Hy6Abh8TDlwLVy2+/pQVtPGMi8UN2D7VRY24TVamd0BHjBgO//e9keiDjL2K5GTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Ju8WL1n9; arc=fail smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IDFVsD2992806;
	Wed, 18 Feb 2026 07:50:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=+fIvxGMXoqjEJSerZy/RC15Z72HKnyNoa5ES/7C9gco=; b=Ju8WL1n9v0zG
	g7iQlXoBtKxpJYiNHKUufGwiGIzZU16GNJjd7XRzS3ZKI1S/be1rXXujm1QB5cH2
	25AWZCtB9L9vvRF/riU8FRWXqe7zu2uFHGU/9GeGtedC+AjZ1dHXcA5tfhv+kAU3
	rt3LH1TZ4H76UZldiyWUhzb+STmoBB4VSCela20DBvwa2RQePrg759tCTXFcc7fI
	/MEFsFYl8rR60Y7gO/F10jtnUeGfwK7ah037IMym2DOSQsex2krodelXRnhcTxa5
	m8I2vxf6Z8UmKV8e0BL3n08sxhVPNoPd8W3rQnwqXlMKw15xltSQrEpVKmxtvjtf
	26BYDdnn+g==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010030.outbound.protection.outlook.com [52.101.46.30])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4cde5cj379-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 07:50:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZvN3DR405mjI1vHtIKy4Rj326gJKLARPxeqKOpSRmtL5I+ppHAT11cg5g9cOr8iVJwI1ZR47Qr6b3uk3aIcspwlFriUuGGjKc8uBx8Sp6ygNz3jgiCX4M1+S6O3J5P/QCOMoE1v+kDFWadXlLW9FAM0snQ+Am95OWfGMNKhS0pCmv9X78Ri9B3smZloFr8J72f+i403LoFhvskYtd/ViUmOIYhirV21iX5RFqxV53hFi1l8faAJatl4dEaihc6Y3tppwi2PuLTxrO+GKt4Yi9/617q32seMJ5Q4g6ewQOrgwvy2kd+G4kxTkeMLUnk3lobnMVX17qLw69h2rrdzFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fIvxGMXoqjEJSerZy/RC15Z72HKnyNoa5ES/7C9gco=;
 b=hLyn+q3sQ5RHKYgDs6YIirKN6SzxYkEaJZVn+UDB8YFLy9L25IS0wLuiZXG6meSQ5oU9Sd+/FGINwoy8s5/7vuKzyYkA2loBeHh3EPQEGgYO/JPuyeXHwqU2yYJu8h2bEbD04KAbuLX76nJUgq6JXqci/eq6ah7d9HRNkPJ8yV0rso45ldrdjL2OQnq+fFfQWnEJmITMHaL2+aA9MFUdgHNEH6xyNXlFDBtZfIfoaQ3Dhj7mv6msiCz13PPdvii4cLOJ35QQpPiBO3NT6CyZeWcYe0TZu/kyw2WxHZHNCZ0OBcMZ2phr2JoTyTMRhm8bEQzWBgwVGr8KTANVXILh7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from LV3PR15MB6455.namprd15.prod.outlook.com (2603:10b6:408:1ad::10)
 by LV2PR15MB5357.namprd15.prod.outlook.com (2603:10b6:408:17e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Wed, 18 Feb
 2026 15:50:15 +0000
Received: from LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5]) by LV3PR15MB6455.namprd15.prod.outlook.com
 ([fe80::444a:f42c:1d70:40b5%4]) with mapi id 15.20.9632.010; Wed, 18 Feb 2026
 15:50:15 +0000
Message-ID: <989433cb-4ab6-4a79-8dfc-9f5f542e2647@meta.com>
Date: Wed, 18 Feb 2026 10:50:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 20/43] btrfs: add fscrypt_info and encryption_type to
 ordered_extent
To: Daniel Vacek <neelx@suse.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        David Sterba <dsterba@suse.com>, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260206182336.1397715-1-neelx@suse.com>
 <20260206182336.1397715-21-neelx@suse.com>
 <20260208151928.3245396-1-clm@meta.com>
 <CAPjX3FdiskLiELriX5gE2YEDMMwz5QQbNDnkAuFVov1a=WL_jQ@mail.gmail.com>
Content-Language: en-US
From: Chris Mason <clm@meta.com>
In-Reply-To: <CAPjX3FdiskLiELriX5gE2YEDMMwz5QQbNDnkAuFVov1a=WL_jQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0058.namprd20.prod.outlook.com
 (2603:10b6:208:235::27) To LV3PR15MB6455.namprd15.prod.outlook.com
 (2603:10b6:408:1ad::10)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR15MB6455:EE_|LV2PR15MB5357:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df6c7dc-5277-498d-10e9-08de6f0568a3
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aU5STjNEcnJYT21uRnNMb3lOYWFaNVVSVFM2dDN4T2ZjVmdiVEpGK3FicWM3?=
 =?utf-8?B?T0VkWTduSUpBaUlyZVFDb2hkdUJrVzFvdVgvKzBoZDFhVXNYWkFpbTNubmh1?=
 =?utf-8?B?RU56eFpGL1NpbE9TYm1neXBTWmFjNXhZdUZVUFZlZnphNDY2STlyS3BFTVJu?=
 =?utf-8?B?aENWSk4rSDZvQVBXN200amhQbEoxQlZNSEYwaFZvRTgvOFpxOXdxQWxZenoz?=
 =?utf-8?B?Und1YVVBSDNYV3ZWNERhRFJCb2s0TnFQUDJ4TjNEOWsrdTRpaWtKelVlU0FR?=
 =?utf-8?B?cFRia0pYWTRtR3ZTYjh0dXlGUUZDRUVicDVpanZzYXErdCtVcmxsczl0aGxp?=
 =?utf-8?B?cGY1TzNLTDJheU90V3U0YlpVNmdzcElCRXlLN1BaZ2hvTWRhcjkvc2RiS25n?=
 =?utf-8?B?cDRIclFEWXpUWHNZMzQxSWpNc2hpV0dubVdjRGowS0lHcnduZlR5VjU4MFEy?=
 =?utf-8?B?L1pqdzlsTlVZT00vZ0pxUTlkR0lUL1R1a0JhcFI4VFdEUXZ0WXNFcVIwcmtK?=
 =?utf-8?B?VE01bmx2OGlLdVJsblc5ejNQK0VBcE5EaVBhR2dEV25Pem5Yb3QwbnlzQ3Jk?=
 =?utf-8?B?Tno0a2U2VGFMOFgzWTQ3MTNYSzYvajMyOWNrdU5sR1lralpWRlowbUVERjF0?=
 =?utf-8?B?d0lxZHJJMk9TSjVpUXNvZytwQjFQUHBDcmJqb2JzSVVlSEp1bFVTeFg4NDVo?=
 =?utf-8?B?bjl4aDRxV2ZpcW1XNVlVN1Fwc3RNeVdKLzdzWHFUOW4zRlAySmxORW5ZQ29m?=
 =?utf-8?B?TkU1ZEFZUFZwbDhudmlrd0IveFNNeUlPMmdCa0JQb0VJVTRubDdqRVFpSGIy?=
 =?utf-8?B?UnA2VktuWXd1eHlXRVZHblNoaHR2UEVaRXNodndlZ2Z5WWJiaVNtZzVqU29R?=
 =?utf-8?B?OE1UZnIzSFBhR3RaMjgxZDYxVXBSaFBrWWNlNHMrekxNUUMxRjQ3b1RCTVBD?=
 =?utf-8?B?Ri8xR0ZrT3RwRndyQkxYaHVZY1RSVFpKSUVtbFVXTGFhZk90KzBsYm5FM0R0?=
 =?utf-8?B?dFZFY3BITjVHSklnaEFqQTJDa1FQaUx1ejcrV3RObWpzam9JcW9kbHJYc25n?=
 =?utf-8?B?MzNvZE5tM3dERURWdzJQYVg2dm5BREZabk0vME9vR05SVzZ4bWdobW1WNGZj?=
 =?utf-8?B?Y1ZNMVZPWVV4THA3ellleDlXWnhvWDdha04vWWpTMUZiVWtkNUxFUXBCVmRG?=
 =?utf-8?B?VDFjRHZ0ZS90R2N5Q2JnQ1pVNVBHUXNKcHpENUlYVUd6dGNGNUg3UEp4bHkz?=
 =?utf-8?B?c1dJS0sycytsdzRzRnVxdzE1K09janVhK0J6S0tDa3dvclNCdTFpZmF5amtW?=
 =?utf-8?B?OG5QckdUcVgzZkl2VjVGRGtIRzljNmdlb2ZqY2NBTk10NWJpR1FjYkZLd0lU?=
 =?utf-8?B?QThpM01FeXovTnZvYlI4a1Q4LzhMeG1qTEtmSE4zU0lpTmxQU3Vma2N4cnRx?=
 =?utf-8?B?bHE3QURkeXBwR2ptL2I0SXBmK3hmUEpHY2lUVUc2QWFhc0JlSjNpT3UyaDV3?=
 =?utf-8?B?Zk9PaWNVaWFGNFpIUG1IeHJGUUY2RXhmSFJSempSdzJFNGprWEU5b09GODRu?=
 =?utf-8?B?cWdOdHV4MUd6Nlp2TGx1V1cxVGNJNkpGYkorNVBQa3AvR2lSdUgvNFNLWXls?=
 =?utf-8?B?NUMxNVhjeVFIYXhUM0xiZHJLYkhRY0VBVk1rbGg5c2c5eFlrWnVvbzRJbm5K?=
 =?utf-8?B?ZHdlclprM1RIU1VVQ1RDL1ZBTG52TDQ1MXE3TWt6aGxpRG5kQlNKeXZha2Js?=
 =?utf-8?B?M0hNc2E2YkcyUHVWKzJiQS9CeGtJVHRaM2xJS3JuNzVMUW56MGpBelZ0NWV1?=
 =?utf-8?B?dGUrNXhic0ZRdG1SdGVIcWZhaDIxWGFWeWJkU3pPVmtOdTd4U1FkSEYyZ1Zo?=
 =?utf-8?B?NlltbjlHQ1dnUjcwQXgvRGRmb2tDU0xyYVlxSWQ3djRRTkdsaDQ2TlYxVFNs?=
 =?utf-8?B?dnBGRjd0T0JvblRIZW5CYU9YaWpYc2hsTFZUSnVJRUJTTCs2Tm8rVDRGZ2ln?=
 =?utf-8?B?NXFnM3o4dko0cCszTDdLSUFKczNYdXdCTVljTkFPcXdtNFpxUm1QT3RTWG5F?=
 =?utf-8?B?L1pQVWFGaE15eG4weWY4TmFuSzNhQm5sWXZIU0hWVnNUV3VjNDUvWkNrZnRR?=
 =?utf-8?Q?fMt0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR15MB6455.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUIxWGF1RmtGVHRURVF0TWtDdmhKdmlTWmRUckVJczBxRHQ0aGZDa1hJYlRj?=
 =?utf-8?B?clcwZXROZU5YdFQybHlKanFPVWs0V0pNYURKU0JJUVFON3p2d0wyVXNhdW5m?=
 =?utf-8?B?bVZ6bUptRnVNYldiZXkvMzV4a1UwRmJ2QXRhamtLVUE2WHhKckhhWGJoMlB0?=
 =?utf-8?B?TEdjcGRoZUQ0SzFGMWREK0UxZnZ4TlQvSFVpVGtFeUp5QnRlMUJFVGV1WG0x?=
 =?utf-8?B?azNiNUJYbHk1NW1sMEtuTS9iNitiS0dwL2VKQ2xBMlBwaU5IcCtvZUg1ZnE1?=
 =?utf-8?B?L20yRnJUSXhMZUFpU05veFdMZG4xbWZPUmhrK1ZNaUwxUUcramdLaVRuNDR6?=
 =?utf-8?B?ajhudmZtRnRYdVJGa0pFN3UyZnNLZFpJSGxhdk9NWkZlZi9jSjhwYnVFU0RS?=
 =?utf-8?B?QlZLd3pWZnFpdGZxdytEaXI4L3BQeFp3RzVhTlZ3T3JTSmx3Q3BWTXNNSE5x?=
 =?utf-8?B?NjJxblVhM25sRnpZZ2NYVXF6VUxZVUNKTTJhbFRTeGI1N3p1VnQ4aFZyTWRq?=
 =?utf-8?B?VExiOWM1ZythSXZralRqNHVKQUs1NlVjOHJPTHVLeHpiTlIzekp6NTlXS2JY?=
 =?utf-8?B?UHlwckZGamlzNy9lWUpGZkIrTkdKTHF6TURLK2dGblMycTJuOHhCek45ZGZl?=
 =?utf-8?B?cjFaNzZ4UWFqWDJWVXZxSVhvWWpwM1ZHbERvclM4K3gxUVVFUXhwTjdBVnA4?=
 =?utf-8?B?NlZ4Z0FDTWNRNmxsVjFiWUVxNGZleGRDTGZOWTBWemtZTWN0U0ZyOCtCK01i?=
 =?utf-8?B?Z3ZxbUNFUXpJdUp4d1lmNUEwUUQ1ZjVEdnE2NzdQd0NNb0VOeW52WGxmcFlp?=
 =?utf-8?B?VzAzV2lXb0dlTFlaMlB6MXl2Q2hqSUhZRFVId3BGOGQ5MlZDTTZ3ZERRdFV6?=
 =?utf-8?B?NDBCc0o2bnpiQU9XVVVIVjJUMG0xK2MxNnJaMlpHK2JHWWVHb1VxeXpiRHBK?=
 =?utf-8?B?UWhtQkNrRzI0QjlMT3Izd29XN2NkVlFLR1o2SSttMHFQZEgwYUxmbFpLLy9N?=
 =?utf-8?B?bllLUFlVMTdXazJVVGwxQkVqL2IvcVlkOUZmS0NkMGVNeDBtSzkvMXRieXhs?=
 =?utf-8?B?c1VhVnFYK096bXR1WW9xK2FrMXdBYUhpRjAwWllnUGpnNUZEZzRNWThZY1NV?=
 =?utf-8?B?UTdqV3BxUUE5SzgrRW5oWXRvVE5mNm8rL0YvZTQvTk5YTjU5aFZhSmNOa0dn?=
 =?utf-8?B?RzJNSHpvOWMra09GZXhlTFRzMDl0b2gyOTZNSFF1ZENrR0pqd0Rva0VBQ3Zn?=
 =?utf-8?B?RWtNUW1PeHh5cEZ2WFVtZzNHS3ArSlV5ZUl0Qk1qR1JNVG12c2RGd3JmLzNm?=
 =?utf-8?B?MS9NYjJzVlNSUzc5eEtTTzhwcy9pSCtlaWJLRitzVEhRdmcxcktuU0w2SU5h?=
 =?utf-8?B?TmZYNFlZTFhEMlAyRlNsMDNnNU1PeXhVVXR5aEg4REZLYkRTQmtmdHB0Q1dS?=
 =?utf-8?B?aFd4WW9iL0pMMVBiZ05CeEFSUFJhTHdMVS84dUtNS0M5NTZpSVFwNjZCT3VG?=
 =?utf-8?B?clBZcElBdXVlOTNvajd6bnphRFRLUDNzOUtVbFpUUFh6dGJPOGFMVEY1enZn?=
 =?utf-8?B?Kzg2SUNzM1BIZnQ5L3JUczg1eUM2OGJSMGRVVnkvR0YyYU92WjlSR0d3TDd6?=
 =?utf-8?B?WHljU2RQVStnZC9KVzFHaXBTVjVLUXR2WUltMVByUndEK0ZkTnN6d0xPRmYv?=
 =?utf-8?B?eUdhNzFicWVlL1NHd2t1TGNNVml1d01kWWcrZ3JvU29KRHQ1c1VsNlozdTdO?=
 =?utf-8?B?K0FOclJKODg3eGxGbFBxZng4cDZDVkcvb21URjNwMXNyQjVTNURvWHlITGNE?=
 =?utf-8?B?UGx2ekhyR0VNN1lDSUdvUVluWC9uZmF5VXd4VWV2TlFHd3I4RXpJTVZob0hF?=
 =?utf-8?B?VDUzenlvS3pneHNuREFQKzRyM2tiYmc3NkVrUndDK2Y3eFF1UW9Gak5ER3pQ?=
 =?utf-8?B?VUpqdnlIeEY4VHFpdk9LMUpuMUcrLzA3Z24wZXFJcjI3a1JXRzhyeURtMzNQ?=
 =?utf-8?B?TFpUQVM1TFFvd2R5aDkxelZQRXpZSEVFaXREVk42aFdQbm9TOHVrMnNmYVN5?=
 =?utf-8?B?WkFwNTdxaUQwSHJUVWhjcEhkanBQcWZ5NzdPazNxUTZnVXZTU0VEcy9tYTds?=
 =?utf-8?B?bDBoSE9qVWhCREhBZGE5THFYQk50TFN2UDljQmpCM29jbGFqMEpyaHhsWDlH?=
 =?utf-8?B?aFQ4TFhCTHlYMXlUWU1uYk5ZT1BIbUU2VWxYaDdXY2l4SW84MFlsaHVkTFJv?=
 =?utf-8?B?ZE5mQXF0RWVJTllYakFrMENvcDJRUjNkWUVMdCtuM2xiZVFYMHhoamVTVmh3?=
 =?utf-8?Q?MKxJmbx8gi6cy+QuDb?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df6c7dc-5277-498d-10e9-08de6f0568a3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR15MB6455.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2026 15:50:15.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KGlsg1vcY7zfVNpAEKtHQpQSjFZYWEnGTheMZPT+YSMnSqzcjmTo4PGbZIvoGKG1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR15MB5357
X-Authority-Analysis: v=2.4 cv=EMkLElZC c=1 sm=1 tr=0 ts=6995dfbf cx=c_pps
 a=7sXfYZKWL/+VDStniiEWIQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22
 a=NEAV23lmAAAA:8 a=VabnemYjAAAA:8 a=iox4zFpeAAAA:8 a=maIFttP_AAAA:8
 a=CouT0FhLiNK77SyPZlkA:9 a=QEXdDO2ut3YA:10 a=gKebqoRLp9LExxC7YDUY:22
 a=WzC6qhA0u3u7Ye7llzcV:22 a=qR24C9TJY6iBuJVj_x8Y:22
X-Proofpoint-GUID: wB0zOAwckWNjAL8ykmLIjRBhkjv-GlQq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDEzMiBTYWx0ZWRfX7Z0CX9BfV9s7
 VO2KLeBRbLtaFNEUB8VMk7bfIKe6ZIKHHqOvLCZqckIpLoqlOVyMVxh9f33j7Z8/Lrk7xIVlEWe
 lxu9dauhs3kTHE90/ZL3gs3HvjQrD28YU+zOO9Xf5KQsfQj1XYeXC4gonc4J27sIVCGdLjNrPAE
 fW5A7uNyuOQL1DZWdFJ/Ggm5b6zOLezZlrxjCFCFKadAZQrobw0q7z6WuIXDxig6MuvOyTEkVeV
 GtORY0l84RqtXK+UsbJ/QSK1eD+VodB832W4/IcdaeywasLAiUPFxza4Gb9Urz+4+dM9BPchbgo
 ymXMcrpxTubznRGdDdfaGaECo3Ycyd2XPCOye22o4UCKEgy8v5CGwOkDxMZPNC1iTwEXTkGS5h1
 WQ51Z5V6f2TjVxNnVDUyj/En72bXKyGCBKdr/fhzjQT0bLEmjpWIOcQQeYxCRdCd8Nh/hXNjUUe
 YHPvNBa3aHCfgsPG2+g==
X-Proofpoint-ORIG-GUID: wB0zOAwckWNjAL8ykmLIjRBhkjv-GlQq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-18_03,2026-02-18_01,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DKIM_TRACE(0.00)[meta.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[clm@meta.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,toxicpanda.com:email,meta.com:mid,meta.com:dkim,meta.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1155-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 28FCA1577DA
X-Rspamd-Action: no action



On 2/18/26 10:29 AM, Daniel Vacek wrote:
> On Sun, 8 Feb 2026 at 16:20, Chris Mason <clm@meta.com> wrote:
>> Daniel Vacek <neelx@suse.com> wrote:
>>> From: Josef Bacik <josef@toxicpanda.com>
>>>
>>> We're going to need these to update the file extent items once the
>>> writes are complete.  Add them and add the pieces necessary to assign
>>> them and free everything.
>>>
>>
>> Hi everyone,
>>
>> I'm running the btrfs for-next branch, along with the encryption patch set
>> through my AI review prompts:
>>
>> https://github.com/masoncl/review-prompts 
>>
>> I'm working on some btrfs specific instructions, but hopefully these reviews
>> are already useful.  I've kept the headers to make it easier to double check
>> that I'm actually replying to the right email, but please let me know if any
>> parts of this are incorrect:
>>
>> commit 61cd57301840de69a3f6573374d41ad4b4bcf348
>> Author: Josef Bacik <josef@toxicpanda.com>
>>
>> btrfs: add fscrypt_info and encryption_type to ordered_extent
>>
>> This commit adds encryption-related fields (encryption_type and
>> fscrypt_info) to struct btrfs_ordered_extent to support fscrypt
>> integration in btrfs.
>>
>>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>>> index 5df02c707aee6..7a5701937184e 100644
>>> --- a/fs/btrfs/ordered-data.c
>>> +++ b/fs/btrfs/ordered-data.c
>>> @@ -192,6 +192,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
>>>       }
>>>       entry->inode = inode;
>>>       entry->compress_type = compress_type;
>>> +     entry->encryption_type = BTRFS_ENCRYPTION_NONE;
>>>       entry->truncated_len = (u64)-1;
>>>       entry->qgroup_rsv = qgroup_rsv;
>>
>> This isn't a bug, but the fscrypt_info field isn't explicitly initialized
>> to NULL here. While kmem_cache_zalloc() at line 175 does zero the memory,
>> all the other important fields in this function are explicitly initialized
>> (compress_type, encryption_type, truncated_len, qgroup_rsv, refs). Would
>> adding an explicit 'entry->fscrypt_info = NULL;' improve consistency?
> 
> `entry->fscrypt_info` is set in the very next patch "[21/43] btrfs:
> plumb through setting the fscrypt_info for ordered extents". The
> series is meant to be applied as a whole. It's just factored into
> implementation steps.

The prompts try to flag any patch series that don't follow best
practices around bisectability.  There isn't a ton of instruction about
what those best practices are beyond if commit A makes bug and then
commit B fixes the bug, flag it.

This patch set is pretty unusual because you're trying to preserve
authorship for a number of people, and so there are a lot of small
judgement calls about when to change patches and when to fix them up
later.  I sent claude's comments to help highlight places we want to
decide things, but I don't think there's really a wrong decision.

> 
>>>       entry->flags = flags;
>>> @@ -630,6 +631,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
>>>               btrfs_add_delayed_iput(entry->inode);
>>>               list_for_each_entry_safe(sum, tmp, &entry->list, list)
>>>                       kvfree(sum);
>>> +             fscrypt_put_extent_info(entry->fscrypt_info);
>>>               kmem_cache_free(btrfs_ordered_extent_cache, entry);
>>>       }
>>>  }
>>> diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
>>> index 1e6b0b182b295..ce19198e7f844 100644
>>> --- a/fs/btrfs/ordered-data.h
>>> +++ b/fs/btrfs/ordered-data.h
>>> @@ -124,6 +124,9 @@ struct btrfs_ordered_extent {
>>>       /* compression algorithm */
>>>       int compress_type;
>>>
>>> +     /* encryption mode */
>>> +     u8 encryption_type;
>>> +
>>
>> This isn't a bug, but placing the u8 encryption_type field between two int
>> fields creates 3 bytes of padding. This is minor, but in a filesystem with
>> many ordered extents, it could add up. The current placement does have the
>> advantage of grouping encryption-related fields together logically, though.
> 
> This was actually changed from int (as Dave suggested, IIRC). But I
> did not move it.
> I guess we can do this:
> 
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -127,18 +127,18 @@ struct btrfs_ordered_extent {
>      /* flags (described above) */
>      unsigned long flags;
> 
> -    /* compression algorithm */
> -    int compress_type;
> -
> -    /* encryption mode */
> -    u8 encryption_type;
> -
>      /* Qgroup reserved space */
>      int qgroup_rsv;
> 
>      /* reference count */
>      refcount_t refs;
> 
> +    /* compression algorithm */
> +    int compress_type;
> +
> +    /* encryption mode */
> +    u8 encryption_type;
> +

Seems mostly the same?  I'd suggest paholing things to find a good spot.

>      /* the inode we belong to */
>      struct btrfs_inode *inode;
> 
> 
>>>       /* Qgroup reserved space */
>>>       int qgroup_rsv;
>>>
>>> @@ -133,6 +136,9 @@ struct btrfs_ordered_extent {
>>>       /* the inode we belong to */
>>>       struct btrfs_inode *inode;
>>>
>>> +     /* the fscrypt_info for this extent, if necessary */
>>> +     struct fscrypt_extent_info *fscrypt_info;
>>> +
>>>       /* list of checksums for insertion when the extent io is done */
>>>       struct list_head list;
>>
>> How does btrfs_split_ordered_extent() handle the new fscrypt_info field?
>> Looking at that function in ordered-data.c, it calls alloc_ordered_extent()
>> which initializes encryption_type to BTRFS_ENCRYPTION_NONE and fscrypt_info
>> to NULL. If the original ordered extent has encryption_type set to
> 
> Ditto. This is changed in the next patch [21/43].
> alloc_ordered_extent() correctly sets these fields.

It seems unlikely that we're really going to maintain bisectability for
encryption being on in the middle of this patchset.  So this seems fine
to me as long as the bug doesn't impact encryption being off.

-chris


