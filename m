Return-Path: <linux-fscrypt+bounces-1640-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5OXSCncbMWrVbgUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1640-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jun 2026 11:46:31 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B29668DAB5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jun 2026 11:46:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=Ap8egWZr;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1640-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1640-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 60EA13015D05
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Jun 2026 09:46:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE14E41C31E;
	Tue, 16 Jun 2026 09:46:28 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013024.outbound.protection.outlook.com [40.107.44.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E3335A384;
	Tue, 16 Jun 2026 09:46:26 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781603188; cv=fail; b=lIeTPtnhH2oyH5yiXxLHgo2ELx66Jbb+cYe+njoCXVuh/4oJnPfBEG/qMBzVOEZl971NZp2bTVvT+3o+jl/SAEKAeB+hIIZ2IUtvgOZQpkLCDHuKOr+4ChNvNy7Vn2zV3JYQqGI6AsBEZGYM7MkxyTqlYsmsoH+Tq3rwkBp/2bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781603188; c=relaxed/simple;
	bh=H83fYrj9XvhFb5i44qB3Zo2OlAVP2u2LHxupGylFnOo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LLRzE1wMoTbgkYJuUTqDILC0+ssoPmOrezZ8JS/12fj6kxLi9BX3hGXmgGOy+XDgWnwdthP7e67QdBkpmjB9E5tiPrqwQAi9XnBoBI5Fd5vXv4TIg1tDxcNSGU69A+zFLX/1Z/PA3P0yZqfV8t+RlpEhR8GaePDSSWyUmP+3Jk4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Ap8egWZr; arc=fail smtp.client-ip=40.107.44.24
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJMfvmsJnIO6IIRxZ6bIpfG93xuOnk6KQzT88eGB+pJhCa5n6cToZB5KFDeOr1NzLFkfuzHVvkU63sXjIx3h7/3USWlQ0xoDmXmUvpMy9HrLUO8d9dSJ4pJjLD4KvYbUuiNkwl8vzG1MsEhrnVMBCqvsvaSgnDTXFzm4euCGriJd2QyvHnuE3HHkYOhCRjtm5deja7QMJDL84Ki9d+qx52pIhFVMAjaRl7/T1Nat+WBzD+/OLlQLRPujD3jpwZmjR8A9a9PMQ95KeHrAdZds77WFdmTPXDcA6/7M9piKZlVHzfclH9Um4xAfOQ7h6GTNuyOlwy+M26TauF/YdtTJhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H83fYrj9XvhFb5i44qB3Zo2OlAVP2u2LHxupGylFnOo=;
 b=hi2WI0MCiuYHABtgeuG0loVRaL3NSMO529IeJiZqi3j++vgqGVTX2zyZnhRvGb044ICzmWoSCa596HujVVXN9IoxM+iXsuuZiGWQfP/chGtqZKv7cyTNPuxsQs0mJXNTGBFfJmqmlMU5dmfTNX6XABp1/kb2yRrljVwoMR+Scsd8SZowy6gDiFMOTGgJAK/pR6Ju/vXx/dHkF3Vj8AgdFV2tRboG1kXRiY1BnosptB8+IQ1d7DoFajnPWLpR5o43fHZs8Itkh7VKOJSkfCjHuzixBQmt1fNmjGoOt/5hszTSt8iA7nrtInXgaYYXa1mAxLKB/FJWzS4ljI9tpNWzNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H83fYrj9XvhFb5i44qB3Zo2OlAVP2u2LHxupGylFnOo=;
 b=Ap8egWZrM7dkuhG4FgV0fmtXaxlsYdfFKek/80VaH7/bMDwn9QGsMDk5bXhSWn29tt/7YJ2IMacOwt0zDEoB4BPCifOSdNnE5parUXoSHPhEAl1QZmMkLFw1UnmYkzKGmI73w1hoX1dDAil5yS7yp5aU+0th4HUlRNTFdqFhQLt/9HkBM4+gpcfuL+H6WMViUaQF8U/Geq8Bk33fqlG1FqhIg44k4CEEQwb62tHJREGBjiLrj/72FcO4yJiuOW7Ugr51FPji6OhlgK7slD9a9mnrSVC2qkDXcGTrqtKhV4kMPf0Fe4vxTrrXtV8yw1wlfALs4CVa8apmhY85l8gUCQ==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by SEZPR06MB5438.apcprd06.prod.outlook.com (2603:1096:101:9a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Tue, 16 Jun
 2026 09:46:23 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0113.015; Tue, 16 Jun 2026
 09:46:23 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: ebiggers@kernel.org
Cc: chao@kernel.org,
	corbet@lwn.net,
	jaegeuk@kernel.org,
	liaoyuanhong@vivo.com,
	linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	tytso@mit.edu
Subject: Re: [PATCH v3 0/3] f2fs: support encrypted inline data
Date: Tue, 16 Jun 2026 17:46:12 +0800
Message-Id: <20260616094612.45505-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615193728.GA1764@quark>
References: <20260615193728.GA1764@quark>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0018.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::7) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|SEZPR06MB5438:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e92ae2-b14c-491d-1a28-08decb8c2048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|52116014|376014|23010399003|38350700014|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	YNINnTguk7H3bsJlV4xadxnP3PoWcftC+Og2DZ7Jk5gFPpit6GledtWfNNPaGtQJSdLM02EQa8aMVvfNOAruHKwW8lCN2FHwwGyK4isNOlOmlDFZi6CDgpVKqe3z3aPogU/WLSzg20Ax28a93oU0SAz2ASQxfgn5E6pRL+lDHNzmKm8vTxzuqM6yGcjvQsWw3Cw8uYIg4pWp7rXCpPDxub/eGWRZkQHBnqdheCaE04qghKlgqTGPQhlqeB8zsesZgKOvaS7t847E9A8d+J6q1joal5UugwT+XHfTxgZdexmEAHAuBVIYf4LgCgPEHlzGtGXaPLIpagtqdoMEoX1CLG4rsUCnTuE63t324y81sbVlL7igRwa/8Nc9ImSfWXcP8RLYNIrcU3b+a0XVhGv0ZWD3zhsEE4FWaXIsHVyarxxGo2MCmVA/6njoJ1eEJMRp5wuSRwspDYpi9qaRV35hFurmHUvLzzEwpmAXMip0D71HjsNh1ORp0IoGKXy7XE872JRHemoQxnV1+1akU8fAIRWpoRKTNMM6MS7BGiqTVMTn5Srd3i6st+ftAoGGhYxwjHiVXfVcX4telbelHCVE3zObWHX9lUYpeIkb39VWy8IQEOOYTU4776jusyu8nXfHmxn7DdftnhCupYZ5mB6+9gnjeSNEP7RWcuUbACk5VziIxUzu+s2fpUh/ckcQs79qh/La3KWMUzDnQ80Bocu4Imqc6AT1bgJN0D6LGeDOg6Oh+VwTlQUNhwh+zN6ZA9eh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(52116014)(376014)(23010399003)(38350700014)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wUfFfoC6PBeQgOG/Qe2RqZd4oMj4+dwKCbOiiVKl3gidIDbVW3mMMVdJ5FRQ?=
 =?us-ascii?Q?aFmuCSYbJK+sz8DDllil1ZgSDRg7nbcYwCtMEvR3FOJASw7G2H/iqwGKnyJg?=
 =?us-ascii?Q?tuo24DF23emBIkPf8an0KupCbeluPQfaIjgyfjJ1l0EQzfF3pS5wJiUHS5UU?=
 =?us-ascii?Q?JJkw3CiXt03QEOxUm7dCcNkM+1Qtdd7VYeTVu4GfqlkPjEd3VV0HZZqL/ry3?=
 =?us-ascii?Q?6bUfXh9pJb+7lXO9YomhQjGAIEjxPiu7/agjN5xQDTKkOiydVSdjiX4DPM0w?=
 =?us-ascii?Q?ZYV9zzh7g6U5U7STjM72VHjqQfBm0bH9gxzwEhZIo4j8YXAZuFAm5R91/+Vl?=
 =?us-ascii?Q?8+FLH4xMd5hYRGWndfND9h6OVMsXV30ma77UL/AfLto481+sYyhRQpBXnoqz?=
 =?us-ascii?Q?7rRVpbZA/6QrBAUBzP5DVWKKtVZIyg6I4hNyuMhO1fDOjqjymY/1R7dMrNnb?=
 =?us-ascii?Q?7IeqpXr7HNb4wpyRo9mhddJcEUM1inyXxLhZH5n8nKZLXS2P1P9CuE9V5/3+?=
 =?us-ascii?Q?V3bUiQMvY42mU9wRxiXvUbjoYYsCSn/SHslh7Xh4nbFqE1OTtYbbsaZdQpUr?=
 =?us-ascii?Q?VB9WZNRvdRucwY6gci/dgUnA44bsMp8kbZQcqpoqXhcDBB/jY6jC13AROFjn?=
 =?us-ascii?Q?IH0S/MzFZeegu4dGK0MKHWI0+g+lyP9Eh0ghtKsf8qarzbID+AomRXMcUTbg?=
 =?us-ascii?Q?iDicv6J33JieEsjLTvI0esW2SuzMwYAPYE1n7bEEd25YtBfQrVJORz6aHPRQ?=
 =?us-ascii?Q?8v6wxJh0QpENlezWOlZMg6GQ6vvnT8YTRD4x9GY/pHNuJHdZdXwce05Tq2tC?=
 =?us-ascii?Q?M203Yp2uxxejORYIbhbiEIObfEjzyu6MPaPfa4uRVeTKyibYTkpwC3xDcPQY?=
 =?us-ascii?Q?Ddn4F/9Z0KYmdJ3SpOUSHfR4Ihg7qtItW9DAv5V38U1drjSiJhji5s66Ra4m?=
 =?us-ascii?Q?IS788yD38MoATwqS1OQGOv/U7yZJAT+HIQHGJbpF6kkrzdf8LPMgW5IV3MWP?=
 =?us-ascii?Q?16vfrvumeTQKyy/4SKXx3w+U8wGwrETcvF/+CTPEY/eoHeEOL5XNPAWZMJK4?=
 =?us-ascii?Q?ql3CCDAw4bdFr9ZLOZhb5dyZQHjFkm9cpVVzvzXJLbHgAN2/5zZ8ptNBZ2+1?=
 =?us-ascii?Q?M3N1qYVXaLZMiptfxAehw7zYNf+6npsoS9wiG/+E4sHhhwetuds2maJPgXU1?=
 =?us-ascii?Q?Ugrqa5jqI930wQvj0CLQWy/0Vz2Wz/lcgkmIWUY0tqJ7TJo73XiWGvEp5/Aa?=
 =?us-ascii?Q?t1rKMTxLKA/eNTB6704yD6sZZzf2SgycCZfH6qm6aoFpnAA02xWRF9TKP83P?=
 =?us-ascii?Q?cA6LjZDbZfZ0Y5TGcEHWYPmM5J2hUXsboMDCKTVTjvKBVa3erxIc4a/yVtU8?=
 =?us-ascii?Q?BNxXzHPLvYC5YsCF3KuXwrVFUlXvRLlSxMBQsqTlzX2CDivSbDUBRsF9d0m5?=
 =?us-ascii?Q?WlzbNM2G2w/GlqFfiE2Nvc4yDynF/wTM8ItKcbI47Uv2EVt6aMWaRh3K/B/2?=
 =?us-ascii?Q?eN9gcsKRMdTe/23acm+J5Dul9AStf5WDhmYAzxsM+UexCZEo5TrzXNLXz3hF?=
 =?us-ascii?Q?bEtztIgjAAajLxADzLs8LF7JbrSrTDuvNkcz/9YGpkmh2fsLWg9k0bvL7GUq?=
 =?us-ascii?Q?vOKsKfwr4hEwso14dubmJa+l3nx9W3KbCRVwB193p1zOGxTVWdivIIxwcrii?=
 =?us-ascii?Q?GC4POVCVnXTmRm0+2zVae+Xsi8I54QnJBtID+ADSJ2K4mEmhb9+OVw2o7/gk?=
 =?us-ascii?Q?UQ9SIWK7ag=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e92ae2-b14c-491d-1a28-08decb8c2048
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2026 09:46:23.3995
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LUF+ajaARsiUT+OeyYKsSQUjw8JlvBCkr0M5ZOUrEVAx2Lk2YOiR3FB3v6SJQLZX8EmOTJYHQu1A7Syrh0VNhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR06MB5438
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:chao@kernel.org,m:corbet@lwn.net,m:jaegeuk@kernel.org,m:liaoyuanhong@vivo.com,m:linux-doc@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-fscrypt@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:skhan@linuxfoundation.org,m:tytso@mit.edu,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-1640-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ALIAS_RESOLVED(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vivo.com:dkim,vivo.com:mid,vivo.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 8B29668DAB5

Hi Eric,

Thanks for the explanation.

I understand the concern about deriving software contents keys from
sw_secret for hardware-wrapped-key files. I agree this is not the right
security model, and I will stop pursuing this direction for now.

Could you share more about the direction you have in mind for simplifying
f2fs/ext4 contents encryption around blk-crypto?

For f2fs inline_data, there is still a real space-saving benefit on phones,
since many encrypted files are smaller than 4K. Is there any acceptable
future direction to support this kind of inode-resident data with
blk-crypto or hardware-wrapped keys?

Thanks,
Liao Yuanhong

