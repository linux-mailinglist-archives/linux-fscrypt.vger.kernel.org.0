Return-Path: <linux-fscrypt+bounces-1638-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id f+7UOVD2L2rRKAUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1638-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 14:55:44 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82ECD68670A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 14:55:44 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=jfVdMePz;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1638-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1638-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AAC51300B5A9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 12:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1593F1ACA;
	Mon, 15 Jun 2026 12:55:37 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013023.outbound.protection.outlook.com [52.101.127.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9B3EFD1F;
	Mon, 15 Jun 2026 12:55:35 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528136; cv=fail; b=F8PUfUapyiIWuLrRKWIQtZV9//MRnV1IvgMW/tDvebjdNJM0T4zqpQfNLL1jnXQDlpLIts2i1W2f0sruHJKsu5QHhBvr6sSqGanDZWXhDpULzaNiZrxj4J+KlBa+1lzlBy6aJ1cpl+Kuw+a59FaLnIGdTkoiu70B/h8KXhgwWVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528136; c=relaxed/simple;
	bh=a5aXG+WYW/c7NT5/FkHr0csUDS413Wr3mMyqaClnABg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AT/MgQp96x2Fqeks1Pa7Rj1sohPsQd/ZjQTLFMnIvDSLdKjl6lU4VpUAzwL+sCZ/8Q7YXNa8ZLs66fe6JstX/paSwgw1Iemy0TawG2hQJ/E85yItKUGOWcGXVEMQJBSJLjFYZfB/Dai8zXvOjv7wxqR+GqmARcN2EhTgxD7J+kk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=jfVdMePz; arc=fail smtp.client-ip=52.101.127.23
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r1h9072UOUHEqp+g9+3iNZqVpT5K4fV8gREEVb+0mp2zhX9aIGRsFbGu2cJnC1vFpHOGm7cg3CRCdeILA6blVYTQ1vPQeYJRuuEnxYXU48pqbz0wbFYlwD86rDKItKUsKWuoNDuxO+vAyzZ/15LzJns1d17q7UEKRJAQtsDi7q6OF9jxvyuPt9SAw0lUTIgQQ+NTWVcA9AHYpBVSnam1n+0qj2ZzDfUYxQuBvrnHRWj9ecJfGWC8R44vdhDwFtGVaiELPyR3vvsoZRtGR3U8pDGvSCTXBPAqUZGRbPAoRtd4NXs5fgnM5K4Fo+YAnF2FFVjVy1i5NRbW/VQ/sDXJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ol8SC+1vWQAsHhYQV2scId2Q+UABH9yvpO24mqfDvhM=;
 b=Au/ypALXSa5DI3Ie7F0XaZ8adcoUCzDgDp67PgksukHqSulcWTBqg1DwieOYmDPb/171qdssPdKkZY5LGh9xBS841v4vC9Q0OiLiBMTS74V0XU3D5Ry52dHqKOjSGFZaWgBHPuDRQCWlmY2KDTpQARuUrAzybXrKPjMI4EI1wDC2p3OXhIBaeob1xeDSJW+a45zOyjumHQZ+5tjpAFdGcZ+CVh6SrsKKwuCOxdDW4SkPQyHQBn9UQ+ya4d5ZOY6b79RabenIKtavazvrwCnZEpzYfqeU7qRD0MUJwKnvSYUzwv9vr7KWbPJ+75KY+uwX11Qw55t9o7p1MYFaA2cGMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ol8SC+1vWQAsHhYQV2scId2Q+UABH9yvpO24mqfDvhM=;
 b=jfVdMePz+paY9eN8+7B+4M4b8U5aXoQtaVX2LhtyJxJF0BwhLzv3lYilaCN8/iadB2f+OQTQC3mrCWhyX6col/XsMclgICuTRfOzfG1N0ZPfVzh2IQD8E2qLPkNiWkKFzEJ5vwpA8h6jZAzKh93+bILBBNR0465OkMpITA20FwFcUd5Q3wO4aVd8NKTTVXXliPuNaLqU1BDZf5xgi3XRu9V666hXsnllWgVLOw7OaE8KR2bOAQaZEE4OkB/SQy51DxOLbLUOaK2Z5F4QIYFGd5cVqycXJaU9y3ViR2vM1RrLPGk0DvtkNQa2vy3x5rKK5dj598dMeYvm91zDFh2CSw==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by OSNPR06MB8687.apcprd06.prod.outlook.com (2603:1096:604:493::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 12:55:31 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 12:55:31 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org (open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Subject: [PATCH v3 1/3] fscrypt: prepare software keys for filesystem-managed data units
Date: Mon, 15 Jun 2026 20:55:13 +0800
Message-Id: <20260615125517.362294-2-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260615125517.362294-1-liaoyuanhong@vivo.com>
References: <20260615125517.362294-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TPYP295CA0031.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:7::9)
 To SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|OSNPR06MB8687:EE_
X-MS-Office365-Filtering-Correlation-Id: fa348dfe-fd33-4b9e-16dc-08decadd621f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|23010399003|1800799024|56012099006|11063799006|6133799003|22082099003|18002099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	GJDOl9i9U12xMhiBerMdKwGr4SIh2z+SWxPm+ZjYJPujHGNpVbvH0KKnNZI8+lMNxUyC73fID1DtQgkMBzjMN1mwHvwekbf3mccxXcXwT4HfnGtA9ha30E8FX6KybFt0wiXjticSzSPgg7S34dNbtHiGphehZKa1RARzn+YUDbhpeEMRoJykcU6zx8Qw7D1WnA2kuKAmKwhI6N6UwWwaTOtUBWp7A5eD/NnQsX9xwOWKUoMOHgKHmkhdzo9kc/LXHBxD7ACReREOPRT8YAusWLmg+Y3LPvTe52xnUFvG0zyKYHU7XyysycdSZO6oCSkJoGyc/l1WxFujqS2IWDJ3FEhHhz8Ddg+ZtYuAyYlBq5aC7snin+M/sqohNJxCHP5LwbP+O7Lj2ssIjeEMt5OBUrpXyub041eWDAg29xPwKJEnBuvS9bh7trGPnzGPI1OIMJMcDc44WigJOlyJOQVsdz6ftnHxI9GF4sFLkq9BH7NBq8/swZZW/ZYS2d6IggKIgzsllIorJYZRb/9yWzm02pFk5TR1SVsg2VYfyqnqESJNGTQRg4V5/H+xFV7PJAOCkfQ0NYhTk9buYMmxwCyF71SEkrF8+5Xt9fsWTjgwom1zhnsxAyizA9yKbgFyFvankeXKXr2Ehga3jW6fDsSjfsp0Ygte9vGd0eQyUcO6w1nTk0DM4tiryJXT7LJYdmND6Od4Vtj5/+pRrU8KPKF03Hnp7wBd1tiGJYRTM7HSKwL4yH2X9O6A1WzKljbtccuZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RN1YACT8TTeX6rWa47lq02sCFttvN/U+e6/tQ2Xc96JAkFhOZj7Pv7jP9aZF?=
 =?us-ascii?Q?fnau5gPkjSwocq6Kcq4RvJbzbRL7ZeQVDiQ9jkAfxX5mmrUWct7c71XWaxDa?=
 =?us-ascii?Q?FbQ4bp/JOw1YbIo3svdWeuAIflw1yXavMVbGcInrW/kiiXILKUG0RCt6QJwq?=
 =?us-ascii?Q?YdiNxsBrUUkxbmUWaus21dowkg5MRpTKJSlpuGxdsnFWTJoUdAkUTN6KmzHt?=
 =?us-ascii?Q?rSsuzj3KY9CY+2oX37uiPtlX1zLPP4PlYVHzislPwIOD+qYuTHwjc12z3TRB?=
 =?us-ascii?Q?G6kzuYe9nvfTXbTxa4q6zIB5t3uPjGFJ1IGLszeZ4+uZhlTKoOagJvGG3qAI?=
 =?us-ascii?Q?9p+CaHvSnNP+MM17xypLm7spG1WDso/5SLwJLdKAzT+N6EqfGTGvPAl1eB+N?=
 =?us-ascii?Q?G2r3jz/WfkhYC1yBIkvUvOTRJmVSioW1ghSIEMfcuxtXxdo4FY6CUvMTCz2y?=
 =?us-ascii?Q?sYks5uyQ0jZs+tjuuAgbhrh/mpmZs2rifIU95XOYSH1S5tJmT1+Rs5rcwjoz?=
 =?us-ascii?Q?LyP7qD9dGr2/fqIRXuqhQo5bIsepoJlVLy6Ot07qlYIajcxnl5EObh553uOv?=
 =?us-ascii?Q?YuleEIWn6zFAWu+3Gc7isDRf08PM0wLYo960tByjBuepgQIAGiff8dHztkga?=
 =?us-ascii?Q?BMP4AiFgjruoi9fKbaA7VHNJQY6WPdhAg/L4vSltD6zui8rcdbLjigtaHvU9?=
 =?us-ascii?Q?7KGjwEQGlUB23qZP9EK8YQLf9FxmZG4MRwbEVyY63lSGPcUse+IY4enSqSB/?=
 =?us-ascii?Q?o2Bipmyp9bz+rUGvM3n0BLEkPA8yXaSuRM0zzr86PzIIv+XmpxAhKBMJv928?=
 =?us-ascii?Q?1PIc9+ryD3ciMDE3inxiJMn0gQlv4ainrsI61pmfuQlsnRUDtJoGbK6U3yS+?=
 =?us-ascii?Q?g2rddd+HshEQO/N9CFDgdHBg4aknAYoupLApU/f3gkzBo4XlnrrUVPoZe03t?=
 =?us-ascii?Q?Lj8vznChb2UazQ3/kJ3y7aJ1LuIBIjXMUzO6dPU3oEIByMf3wVdxHmBedS6T?=
 =?us-ascii?Q?0njM5vuwoLGKV3quiVQnaNBTcKx4pveaG/yXkm4ekVLbQW9Awr19nJ9PWlh7?=
 =?us-ascii?Q?AEU7mCX7z3o9cD6RGJhA6iLZzF1j/UkWmA8rgvjjcdlz4jpuhKx7Bi89kk1x?=
 =?us-ascii?Q?0NkkXOnS4LgmRwrK5xpav6u0a4pNZab5xAsdYMWJHZOZhGVNxWxe5dmi7FWa?=
 =?us-ascii?Q?GrfJypC5fhANjZZzm0njWBNIBduHi4N04lFHqbS+qWwJwoyQkFHmVsq3iifF?=
 =?us-ascii?Q?0Sus3fPw4/Nz+be65AsI0fj9o3afriR+EjNvy5UYdH+QaGhDWc7RLbuZah/R?=
 =?us-ascii?Q?YJ9gf1lnm+S6TroVveeAD2+r0yabKvSIRdb/kz31AkchOZ1ky3LSUwiAgXrj?=
 =?us-ascii?Q?/loZPysIh1JzpQbDAETQZ3E7mxTxxztQPvx7pACwJ+lk5RCoqSia49qHwjkR?=
 =?us-ascii?Q?vWU4FtQySWgVPe0Lxo+Q7GoRwc6phqC6CxTM83YVeJYD9tMzJ/0FG9R73ih+?=
 =?us-ascii?Q?3Wfd6YEpbVd3xbb9DXx8i2P/H4sqtdJhfQl5niY27opIt1k8v5llFvVZxdkJ?=
 =?us-ascii?Q?2W2U6lN8FHzttf5Odaw97XmELiWN5kkIS5bZB++lDZqH1X36PE9g+k/Ddrrs?=
 =?us-ascii?Q?B0NW9MMNV3dVIyPY+jYQQiRBcZrVGFMx7HBkyvi8fdBq7FTl1WYQ4fl3lheL?=
 =?us-ascii?Q?NDsHmHqDFPfUQGyZ/RhGTSXkreN1d/KbmQWP5+V1qXAnH/kfMrr6glXjjt5K?=
 =?us-ascii?Q?X5RmUNUbKQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa348dfe-fd33-4b9e-16dc-08decadd621f
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 12:55:31.7487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yk4GUf/4NoUqKWXPoPrOQrvNSHWdIJvcTD2Cn01yRHWDbHD/pnUVJPVaGwaQHEuG94gkuDj+2roRI58+SMTfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR06MB8687
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1638-lists,linux-fscrypt=lfdr.de];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:tytso@mit.edu,m:jaegeuk@kernel.org,m:linux-fscrypt@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:liaoyuanhong@vivo.com,s:lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vivo.com:dkim,vivo.com:email,vivo.com:mid,vivo.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 82ECD68670A

Some filesystems store small data regions inside filesystem metadata rather
than submitting them through the normal bio path.  F2FS inline data is one
such case.  When encrypted file contents normally use blk-crypto, these
filesystem-managed regions still need software fscrypt handling because no
data bio is submitted for them.

Add helpers for this case.  fscrypt_supports_data_unit_inplace() lets a
filesystem check whether an inode's current key and policy can support this
path without preparing a software transform.
fscrypt_prepare_data_unit_inplace() prepares the transform when the
filesystem actually needs to read or write such a region.
fscrypt_crypt_data_unit_inplace() encrypts or decrypts an in-page region by
fscrypt data-unit size.

Inlinecrypt support is limited to v2 IV_INO_LBLK_64 and IV_INO_LBLK_32
policies, including hardware-wrapped key configurations supported by
fscrypt.  Per-file inlinecrypt keys and DIRECT_KEY policies are not
supported for this path.

Signed-off-by: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
---
Changes in v3:
- Support fscrypt's v2 IV_INO_LBLK_64/32 hardware-wrapped key
  configurations.
- Drop DIRECT_KEY support.

 fs/crypto/crypto.c          |  47 ++++++++++
 fs/crypto/fscrypt_private.h |   3 +-
 fs/crypto/keysetup.c        | 174 ++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h     |  24 +++++
 4 files changed, 247 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945..c4f3ad8f82c9 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -208,6 +208,53 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 }
 EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
 
+/**
+ * fscrypt_crypt_data_unit_inplace() - En/decrypt data units in-place
+ * @inode:   The inode to which these data units belong
+ * @page:    The page containing the data units to en/decrypt
+ * @len:     Size of the region to en/decrypt.  This must be a multiple of
+ *	     FSCRYPT_CONTENTS_ALIGNMENT.
+ * @offs:    Byte offset within @page at which the region begins
+ * @index:   Fscrypt data unit index of the start of the region
+ * @encrypt: True to encrypt, false to decrypt
+ *
+ * Return: 0 on success; -errno on failure
+ */
+int fscrypt_crypt_data_unit_inplace(const struct inode *inode,
+				    struct page *page, unsigned int len,
+				    unsigned int offs, u64 index, bool encrypt)
+{
+	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+	unsigned int du_size;
+	unsigned int i;
+	int err;
+
+	/*
+	 * Pairs with the smp_store_release() that publishes ->tfm after the
+	 * software transform has been fully initialized.
+	 */
+	if (!ci || !smp_load_acquire(&ci->ci_enc_key.tfm))
+		return -EOPNOTSUPP;
+	du_size = 1U << ci->ci_data_unit_bits;
+
+	if (WARN_ON_ONCE(len <= 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!IS_ALIGNED(len | offs, FSCRYPT_CONTENTS_ALIGNMENT)))
+		return -EINVAL;
+
+	for (i = 0; i < len; i += du_size, index++) {
+		unsigned int todo = min(du_size, len - i);
+
+		err = fscrypt_crypt_data_unit(ci,
+				encrypt ? FS_ENCRYPT : FS_DECRYPT,
+				index, page, page, todo, offs + i);
+		if (err)
+			return err;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(fscrypt_crypt_data_unit_inplace);
+
 /**
  * fscrypt_encrypt_block_inplace() - Encrypt a filesystem block in-place
  * @inode:     The inode to which this block belongs
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8d3c278a7591..b5c0b881fd4b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -236,7 +236,8 @@ struct fscrypt_symlink_data {
  * @tfm: crypto API transform object
  * @blk_key: key for blk-crypto
  *
- * Normally only one of the fields will be non-NULL.
+ * Most users need only one prepared form.  Inline-crypto users that also need
+ * filesystem-layer software crypto for non-bio data regions may prepare both.
  */
 struct fscrypt_prepared_key {
 	struct crypto_sync_skcipher *tfm;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ce327bfdada4..399b442578cc 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -400,6 +400,180 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 	return 0;
 }
 
+static int fscrypt_prepare_data_unit_inplace_software_key(
+					struct fscrypt_prepared_key *prep_key,
+					const u8 *raw_key,
+					const struct fscrypt_inode_info *ci)
+{
+	struct crypto_sync_skcipher *tfm;
+
+	/* Pairs with the smp_store_release() below. */
+	if (smp_load_acquire(&prep_key->tfm))
+		return 0;
+	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	/* Pairs with the smp_load_acquire() above and other ->tfm readers. */
+	smp_store_release(&prep_key->tfm, tfm);
+	return 0;
+}
+
+static int fscrypt_prepare_per_mode_data_unit_inplace_key(
+					struct fscrypt_inode_info *ci,
+					struct fscrypt_master_key *mk,
+					struct fscrypt_prepared_key *keys,
+					u8 hkdf_context, bool include_fs_uuid)
+{
+	const struct super_block *sb = ci->ci_inode->i_sb;
+	struct fscrypt_mode *mode = ci->ci_mode;
+	const u8 mode_num = mode - fscrypt_modes;
+	struct fscrypt_prepared_key *prep_key;
+	u8 mode_key[FSCRYPT_MAX_RAW_KEY_SIZE];
+	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
+	unsigned int hkdf_infolen = 0;
+	int err;
+
+	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
+		return -EINVAL;
+
+	prep_key = &keys[mode_num];
+
+	BUILD_BUG_ON(sizeof(mode_num) != 1);
+	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
+	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
+	hkdf_info[hkdf_infolen++] = mode_num;
+	if (include_fs_uuid) {
+		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
+		       sizeof(sb->s_uuid));
+		hkdf_infolen += sizeof(sb->s_uuid);
+	}
+
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context, hkdf_info,
+			    hkdf_infolen, mode_key, mode->keysize);
+	err = fscrypt_prepare_data_unit_inplace_software_key(prep_key,
+							    mode_key, ci);
+	memzero_explicit(mode_key, mode->keysize);
+	if (!err)
+		ci->ci_enc_key = *prep_key;
+	return err;
+}
+
+/**
+ * fscrypt_supports_data_unit_inplace() - check data-unit crypto support
+ * @inode: an encrypted regular file inode
+ *
+ * Check whether filesystem-managed data regions can use fscrypt contents
+ * encryption for this inode.  This path is limited to v2 IV_INO_LBLK
+ * policies, including hardware-wrapped key configurations supported by
+ * fscrypt.  Per-file inlinecrypt keys and DIRECT_KEY policies are
+ * unsupported.
+ */
+bool fscrypt_supports_data_unit_inplace(const struct inode *inode)
+{
+	struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+	struct fscrypt_master_key *mk;
+	u8 flags;
+	bool supported;
+
+	if (!ci)
+		return false;
+	/*
+	 * Pairs with the smp_store_release() that publishes ->tfm after the
+	 * software transform has been fully initialized.
+	 */
+	if (smp_load_acquire(&ci->ci_enc_key.tfm))
+		return true;
+	if (!fscrypt_using_inline_encryption(ci))
+		return false;
+
+	mk = ci->ci_master_key;
+	if (!mk)
+		return false;
+
+	down_read(&mk->mk_sem);
+	if (!mk->mk_present ||
+	    ci->ci_policy.version != FSCRYPT_POLICY_V2) {
+		supported = false;
+		goto out;
+	}
+
+	flags = ci->ci_policy.v2.flags;
+	supported = flags & (FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
+			     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);
+out:
+	up_read(&mk->mk_sem);
+	return supported;
+}
+EXPORT_SYMBOL_GPL(fscrypt_supports_data_unit_inplace);
+
+/**
+ * fscrypt_prepare_data_unit_inplace() - prepare software data-unit crypto
+ * @inode: an encrypted regular file inode
+ *
+ * Prepare the software transform used by filesystem-managed data regions that
+ * need fscrypt contents encryption but do not go through a data bio.  If the
+ * inode already uses filesystem-layer encryption, the normal contents key is
+ * already prepared.  If the inode uses blk-crypto with a v2 IV_INO_LBLK
+ * policy, this prepares the corresponding software transform for the
+ * filesystem-managed data region.
+ */
+int fscrypt_prepare_data_unit_inplace(const struct inode *inode)
+{
+	struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+	struct fscrypt_master_key *mk;
+	u8 flags;
+	int err = 0;
+
+	if (!ci)
+		return -ENOKEY;
+	/*
+	 * Pairs with the smp_store_release() that publishes ->tfm after the
+	 * software transform has been fully initialized.
+	 */
+	if (smp_load_acquire(&ci->ci_enc_key.tfm))
+		return 0;
+	if (!fscrypt_using_inline_encryption(ci))
+		return -EOPNOTSUPP;
+
+	mk = ci->ci_master_key;
+	if (!mk)
+		return -EOPNOTSUPP;
+
+	down_read(&mk->mk_sem);
+	if (!mk->mk_present) {
+		err = -ENOKEY;
+		goto out_unlock;
+	}
+	if (ci->ci_policy.version != FSCRYPT_POLICY_V2) {
+		err = -EOPNOTSUPP;
+		goto out_unlock;
+	}
+
+	mutex_lock(&fscrypt_mode_key_setup_mutex);
+	/* Pairs with fscrypt_prepare_data_unit_inplace_software_key(). */
+	if (smp_load_acquire(&ci->ci_enc_key.tfm))
+		goto out_mutex;
+
+	flags = ci->ci_policy.v2.flags;
+	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
+		err = fscrypt_prepare_per_mode_data_unit_inplace_key(ci, mk,
+				mk->mk_iv_ino_lblk_64_keys,
+				HKDF_CONTEXT_IV_INO_LBLK_64_KEY, true);
+	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
+		err = fscrypt_prepare_per_mode_data_unit_inplace_key(ci, mk,
+				mk->mk_iv_ino_lblk_32_keys,
+				HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
+	} else {
+		err = -EOPNOTSUPP;
+	}
+out_mutex:
+	mutex_unlock(&fscrypt_mode_key_setup_mutex);
+out_unlock:
+	up_read(&mk->mk_sem);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fscrypt_prepare_data_unit_inplace);
+
 /*
  * Check whether the size of the given master key (@mk) is appropriate for the
  * encryption settings which a particular file will use (@ci).
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 54712ec61ffb..2702bf1018c1 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -346,6 +346,12 @@ void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
 struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags);
+
+bool fscrypt_supports_data_unit_inplace(const struct inode *inode);
+int fscrypt_prepare_data_unit_inplace(const struct inode *inode);
+int fscrypt_crypt_data_unit_inplace(const struct inode *inode,
+				    struct page *page, unsigned int len,
+				    unsigned int offs, u64 index, bool encrypt);
 int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
@@ -519,6 +525,24 @@ static inline struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline bool fscrypt_supports_data_unit_inplace(const struct inode *inode)
+{
+	return false;
+}
+
+static inline int fscrypt_prepare_data_unit_inplace(const struct inode *inode)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int fscrypt_crypt_data_unit_inplace(const struct inode *inode,
+						  struct page *page, unsigned int len,
+						  unsigned int offs, u64 index,
+						  bool encrypt)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_encrypt_block_inplace(const struct inode *inode,
 						struct page *page,
 						unsigned int len,
-- 
2.34.1

