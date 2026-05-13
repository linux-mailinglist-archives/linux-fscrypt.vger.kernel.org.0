Return-Path: <linux-fscrypt+bounces-1603-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DskMGhNBGrNGgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1603-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 12:07:36 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFA95311FA
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 12:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 94569303716E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:04:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AE838F630;
	Wed, 13 May 2026 10:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="Lin1GWcN"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012063.outbound.protection.outlook.com [40.107.75.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D90F38BF8D;
	Wed, 13 May 2026 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778666695; cv=fail; b=p02JY4zL2uIwb61GgiukiCSSSiMt9UWBhQ3ilkTWaMFglCUGaO4VXFyTtcguFQUKj57Q8MzM8fkKAYn7+eU5g0bzvdDeGnC93BxnhepanT9reCEanhN4hDsuYHwnUmcluVrHGsuUAshilg7bzRwugQofvR54HQVLxxNF+rnCV6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778666695; c=relaxed/simple;
	bh=hAlZhBoafID94WCU7fyyHehqL/3Ib/g4r2Utg9DbjuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=vBCs/wyf7lWCFbbp/04pcaw3qs/+6V2vQkw5uF34sVlxZ5B3HvR2mFrYxIkGlM3mGxj7jnOI4McVw06tsO8sUFaT8wLtxo9R176FcZfk4e2X+rVEfMQNsELiKTi4Ia8JpOgYxgzyIRH7UvuVfD+iaskpaxwb3YS/eWQCs4REuKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=Lin1GWcN; arc=fail smtp.client-ip=40.107.75.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xgt0xVJH+sXTSOqnK2NzY+Og9wU5QyFVjopBn3I8mTSga2wKnxYLAy5DPmOL+CSdcwuUy7nVKm0WKwjiGuu2WXDuhC+y4MTesOSWT5v2eSlCjqsTs6JHgj3c+WTkuoENIcTY71QlnD/OcaUh7EFDfkYqeqRy4iEG5dH/ieR+dzMwR2jMgdlyAJTei4cHxQTP7LRqcivykLsDzeQv8zBVRArsIOKMhmneUk1Vf9kAN322Z7VHDjbh19KJdqsZt3P74MOjcbU0rEGqe0hVok1gWznspAH86lYzfjTP/jiMQg+t+zUaKwxhPRwCWKi5UJH3taDg/yE8RGyoa/6brLYIXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5m1uc7/eiXDUKn+ZoocdI1FUxm3ZTVaYfTkV0yo4zNM=;
 b=zQo0dkLu10/WqiO/Ym32gSek5+GaoUCe5gB074iSm9VvwwlcWwLHa/n9iKMz9vw2WWO/8/byTDJf4wcyzENA2Sc2iBwDDY1XNuyvwqmwbAyU6Y0cE6z8EnWTkVaIF4KAITQ41e0QmxwCFSdhTzWqfuAYwv2du0/mhHZeSyGldacLIQZarUIGLJbZctveRH4lfSTQq2cvs4zONmZ5DNmGcbWBFqczcyZdRd3NGutMcx3g8dca1Ea3UZns78JbKOWn/mUG2B1kE7wDR1vCwjc7nYyJpaSA7t9tcRcU2+gQYhsoDHSQ9U4h3GEv4t4URlPeXaoK0ZPrCYETwC6XUA+hkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5m1uc7/eiXDUKn+ZoocdI1FUxm3ZTVaYfTkV0yo4zNM=;
 b=Lin1GWcN9zagpgcsGUEGuOiZbDObaaHoAzwGlYxpp52gTHANJHbpZQ+dihAOmfHcYCSmZJBdhUCXLGB1NjBNbqP19/szJMSvCtUAhVlVbu6e2iljcPXKyjv6vHG7xKa0gPOXAEiKh+SAbfVv4NDFwn+tJ0U9A6fegtbsS9CLG5EM5FEq9v1Zo4xbk1x8TAw/m/GLmQUXz5OqFx7u1m6lZV211bQavWtxC3zBd3aJWxxppDSo2ee1t+HXYNWVHK1atLTDR7WwkLgYRQgz12KHxmUQxQ8B1kt+LGdVdZtvGGWDMIzek/EFspsZyNhUlv78s+5eQ7rPLt30mO2IkS28jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB5884.apcprd06.prod.outlook.com (2603:1096:820:dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 10:04:46 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 10:04:46 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org (open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 1/3] fscrypt: prepare software keys for filesystem-managed data units
Date: Wed, 13 May 2026 18:04:28 +0800
Message-Id: <20260513100431.299904-2-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260513100431.299904-1-liaoyuanhong@vivo.com>
References: <20260513100431.299904-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0031.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::12) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|KL1PR06MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: c6e515fd-0b15-47df-9a5d-08deb0d70ff0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|22082099003|18002099003|11063799003|56012099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	/f+MsaqeBBoJC8Tp8R7rXgFDjposBLlK29bxHJTp5NnDSzpy2H41PFI7F/6iK8Pl80ZNCDft8FMSeWF3GiJocUqphqTo8IxG7/gnZ4WWzGTLru7s+OCfZ3+MNEY28d5RCqu3ymgPtTIFuesSiKGhG4/g+4O6WXL5LsdCtSdz8FD4Xu+D1+LZchmuEhMFaglp9VacsOE+Fv0A3TNh8VU5OId5NzPqTFivK2WGTGMJFF45a2bqoOyAgBF7pOJ/xzIYNNqbWKgOra8DMwgqYg6aoFeREaaBGk2sH9V8OJj3jqQ0MvB5J3ca4b/ILG+asHjUoJqaXkLL2k50fcoj/ml7CcUy6gPU2A0u9illYeNhyf+kr6p/h84pCjWG3D4hJizyAufGuoXVvAZbHozXi1F3rzn46UKRPZodOrPdp5LQ8vX2fTHIRninq0M7eXYVI+m39TqzmTkMTw4uLeGRgTKJJir3M+LRYpJ9JjoEgeLcJAQcM1irsKTfMWH/mu0Qy6WuCMUpTQvv6NVz8gFcJKUnIKhQWeLPR0IhNpxD0ocLO3Fy4dCg/wcGmUaHl0fglmDGxTZM6AF+g4icJof8tCzK/dDLrkl0aQ83JPkjEY0ny9FbpQObeZVUWwN3uqwydmrqWmzA1/Dzb0LFoXUSPzPFoZ1f6BGZ7SdLnt6o0N6kBCWFuWxID6yxVdblONQg+D4bcw2vSpBXo7hGmJ9j0JQeMzHLx85DDNKOjqDy8vL4V8M7+kb3gqDlm+EkBHkEUYo6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(22082099003)(18002099003)(11063799003)(56012099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kjh2nlPZoGdKDv0Y5wTfusFgy57NQrDzCHesL3XZZAt25cffh1rfsnH7bSnE?=
 =?us-ascii?Q?zqyBFN8qhzFzd7J1n/XIwte34CpZ+teR1IfzPMokD2rZsNW3EgKxOEF+sZJm?=
 =?us-ascii?Q?cJ+j3qSL1qNa4wBnG930UkGotDDPsrcfvNb0pshjV7JSuocj50q4W6+SaFk7?=
 =?us-ascii?Q?368gfM3F34gERAeeYscvfVVBcR/yaPWTRQUO7ybFK0KLe571WtQpA0y0eouo?=
 =?us-ascii?Q?W/+DX5omN1drstWAEIo1zurPlYahoQCYVJqpeH9QmX0YH4gpVyiOWV/N2Mp5?=
 =?us-ascii?Q?bhR8NmdaoqOxeM0q48OLjdB0xWXxnPLSqprA9Au5C2wbeLhZUsxp9Q2fEIH+?=
 =?us-ascii?Q?VaRamgKbZSCyOOTvVW2g4/JpOnzIqQNsuTO4x99w+r4aCuWI3p+D+bcPMKOu?=
 =?us-ascii?Q?rWBBl2uvDa0V5Nmkv9NFV8TzGy0m33YODfRDSHn8xTkRfN3IKoKt3LdMYYWF?=
 =?us-ascii?Q?pw1vAvzqOz/ByVto7IfRf82oeB4Dc0mTwcFvQCTt75jnzvaN5eEPZFNHeWPt?=
 =?us-ascii?Q?L/VC3KBRjDUKMmIVuxSRzbx+2TtSJdR2fEIGUIdm8J8x9xPm6uk12C4F9CQL?=
 =?us-ascii?Q?Dn5LDE8d2ozuUHL6O1CAfYf3dMXkmYxNiS4+bss5+TM+i19l3+uMeTlOVAwe?=
 =?us-ascii?Q?LBp3R/IE0j22h4StItuylRPR+5Rar4q3xz7jAJUTOnoYVifHiaXolluiwFIt?=
 =?us-ascii?Q?MKpHfYN4QRPDKJuV9tauCriqhnX9tYY1NjqdpdTGTSJ4tuuJ6iqxgRCPcVZT?=
 =?us-ascii?Q?RVzd51kGAIuqbCGv1ZMpU8iU/lj1RcG+QH6miUl7IgPtPkFKNwseaZ1jue+x?=
 =?us-ascii?Q?PUBrkp+llSLqkZhbizwXTXCLh0cj1+nBw/fAwet/Zj71TuuW7sNssGk9DMbT?=
 =?us-ascii?Q?l3UI0KtVc94CmyKEGWZRcjBKfNlHH9PUi5wwfH9zMwbuRnjXQi5vj0ueEsWf?=
 =?us-ascii?Q?wKzwewoE/LBUdt9vWRZxp1hy69qIMJY5pvG1fQlBmZukb2zJ8bf7tmjiTrra?=
 =?us-ascii?Q?YJSdYtEgrsi0x3KYBJIp5Rdx4/7qPFr9uH8VpuQbaTZD0uNYApcH4XWE7+dC?=
 =?us-ascii?Q?mHVw2O8Ucv01w/4w3hG1C7EspWvhVf8Dn6mdTwdo4WDKsoAAPmq6LL8Sao52?=
 =?us-ascii?Q?9SjbbG+RYtRQzufKJH96fo4ySQwMIaeyneueQ7d6jedwzB1R73h2/hMpXuZB?=
 =?us-ascii?Q?Jc6Nmf0U9MUVRHVPhx2xEPosS6ABT0JrSMqtohizHggb3dKkacKWvyzVpxp/?=
 =?us-ascii?Q?GmRgj6RxYoUvozSOwmZDCQ7xYpi44JnEhZy9T616fhzqAQD8+WhywWO6aZHA?=
 =?us-ascii?Q?nx4ueTZAMGVAq6qRcduHg8YTMH24gTMTuNmZW/bhcaPRXHU82JZ5hoUk/Vv8?=
 =?us-ascii?Q?4putCDeurYsbLC33uJfSRvZnkGuirk+unV7Qszygt9N9LAcyzo0q2Up22rgh?=
 =?us-ascii?Q?kmTuoPUicHVHCdO6AD99Vu+HNIpiwTX3cMCpRLqmT5vlrZ20g3v20Y1wzSEn?=
 =?us-ascii?Q?9GRNgsxht45gFz1q1+D2OsxHoHQEn+IeyGuBAXjCKgAP9tG687t46E0kAkBl?=
 =?us-ascii?Q?FHsGii1cF4FFb48tJv/C2x5hRnU6SF4WSmA0b1VHkipewn6CAlllcDHQxQ6J?=
 =?us-ascii?Q?fF0Tb8h8MdGn/l8jMQ+WFoZkxVC66HQ7wMPe2KndAld09vlHVU6rgDZzGItK?=
 =?us-ascii?Q?eznCbL2xAIP2dQepI1skJ8MqBYTpCt8HsmTxinch/dn8Obu/49TqapxZm+dd?=
 =?us-ascii?Q?I2Npizb1IA=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6e515fd-0b15-47df-9a5d-08deb0d70ff0
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 10:04:46.6948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7HnA2Cchm215VNv3m933tAR0Bq09fNCkiIh5o33J0DPAGKg47oTdawDB2heg7ZhDBabJfT2H0NMlS1NnM0SxbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5884
X-Rspamd-Queue-Id: 0DFA95311FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1603-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vivo.com:email,vivo.com:mid,vivo.com:dkim]
X-Rspamd-Action: no action

From: Liao Yuanhong <liaoyuanhong@vivo.com>

Some filesystems store small data regions inside filesystem metadata rather
than submitting them through the normal bio path.  F2FS inline data is one
such case.  When an encrypted file uses blk-crypto, these regions still
need software fscrypt handling because no data bio is submitted for them.

Add fscrypt_encrypt_data_unit_inplace() and
fscrypt_decrypt_data_unit_inplace().  They use the same data-unit crypto
path as fscrypt_encrypt_block_inplace() and
fscrypt_decrypt_block_inplace(), but take a data-unit index instead of a
filesystem logical block number.

Also add fscrypt_inode_supports_data_unit_inplace() so filesystems can
check whether an inode has a software transform available for this path.

Factor the software skcipher setup into fscrypt_prepare_software_key().
The existing fscrypt_prepare_key() path now reuses it, and inline-crypto
key setup can use it in addition to preparing the blk-crypto key.  This
lets an inline-crypto inode keep its normal blk-crypto contents path while
also having a software transform for filesystem-managed data units.

Signed-off-by: Liao Yuanhong <liaoyuanhong@vivo.com>

---
 fs/crypto/crypto.c          | 63 +++++++++++++++++++++++++++++++++++++
 fs/crypto/fscrypt_private.h |  3 +-
 fs/crypto/keysetup.c        | 59 +++++++++++++++++++++++++---------
 include/linux/fscrypt.h     | 28 +++++++++++++++++
 4 files changed, 138 insertions(+), 15 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945..c43acbc8b4ea 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -208,6 +208,44 @@ struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 }
 EXPORT_SYMBOL(fscrypt_encrypt_pagecache_blocks);
 
+/**
+ * fscrypt_encrypt_data_unit_inplace() - Encrypt a data unit in-place
+ * @inode: The inode to which this data unit belongs
+ * @page:  The page containing the data unit to encrypt
+ * @len:   Size of data unit to encrypt.  This must be a multiple of
+ *	   FSCRYPT_CONTENTS_ALIGNMENT.
+ * @offs:  Byte offset within @page at which the data unit begins
+ * @index: Fscrypt data unit index within the file
+ *
+ * Return: 0 on success; -errno on failure
+ */
+int fscrypt_encrypt_data_unit_inplace(const struct inode *inode,
+				      struct page *page, unsigned int len,
+				      unsigned int offs, u64 index)
+{
+	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+
+	if (!fscrypt_inode_supports_data_unit_inplace(inode))
+		return -EOPNOTSUPP;
+
+	return fscrypt_crypt_data_unit(ci, FS_ENCRYPT, index, page, page, len,
+				       offs);
+}
+EXPORT_SYMBOL(fscrypt_encrypt_data_unit_inplace);
+
+bool fscrypt_inode_supports_data_unit_inplace(const struct inode *inode)
+{
+	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+
+	if (!IS_ENABLED(CONFIG_FS_ENCRYPTION_INLINE_CRYPT))
+		return false;
+	if (!ci)
+		return false;
+	/* pairs with smp_store_release() in fscrypt_prepare_software_key() */
+	return smp_load_acquire(&ci->ci_enc_key.tfm);
+}
+EXPORT_SYMBOL(fscrypt_inode_supports_data_unit_inplace);
+
 /**
  * fscrypt_encrypt_block_inplace() - Encrypt a filesystem block in-place
  * @inode:     The inode to which this block belongs
@@ -282,6 +320,31 @@ int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
 }
 EXPORT_SYMBOL(fscrypt_decrypt_pagecache_blocks);
 
+/**
+ * fscrypt_decrypt_data_unit_inplace() - Decrypt a data unit in-place
+ * @inode: The inode to which this data unit belongs
+ * @page:  The page containing the data unit to decrypt
+ * @len:   Size of data unit to decrypt.  This must be a multiple of
+ *	   FSCRYPT_CONTENTS_ALIGNMENT.
+ * @offs:  Byte offset within @page at which the data unit begins
+ * @index: Fscrypt data unit index within the file
+ *
+ * Return: 0 on success; -errno on failure
+ */
+int fscrypt_decrypt_data_unit_inplace(const struct inode *inode,
+				      struct page *page, unsigned int len,
+				      unsigned int offs, u64 index)
+{
+	const struct fscrypt_inode_info *ci = fscrypt_get_inode_info_raw(inode);
+
+	if (!fscrypt_inode_supports_data_unit_inplace(inode))
+		return -EOPNOTSUPP;
+
+	return fscrypt_crypt_data_unit(ci, FS_DECRYPT, index, page, page, len,
+				       offs);
+}
+EXPORT_SYMBOL(fscrypt_decrypt_data_unit_inplace);
+
 /**
  * fscrypt_decrypt_block_inplace() - Decrypt a filesystem block in-place
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
index ce327bfdada4..716911b97d8e 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -144,6 +144,23 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 	return ERR_PTR(err);
 }
 
+static int fscrypt_prepare_software_key(struct fscrypt_prepared_key *prep_key,
+					const u8 *raw_key,
+					const struct fscrypt_inode_info *ci)
+{
+	struct crypto_sync_skcipher *tfm;
+
+	/* pairs with smp_store_release() below */
+	if (smp_load_acquire(&prep_key->tfm))
+		return 0;
+	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	/* pairs with smp_load_acquire() above */
+	smp_store_release(&prep_key->tfm, tfm);
+	return 0;
+}
+
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
  * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
@@ -153,24 +170,12 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 int fscrypt_prepare_key(struct fscrypt_prepared_key *prep_key,
 			const u8 *raw_key, const struct fscrypt_inode_info *ci)
 {
-	struct crypto_sync_skcipher *tfm;
-
 	if (fscrypt_using_inline_encryption(ci))
 		return fscrypt_prepare_inline_crypt_key(prep_key, raw_key,
 							ci->ci_mode->keysize,
 							false, ci);
 
-	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-	/*
-	 * Pairs with the smp_load_acquire() in fscrypt_is_key_prepared().
-	 * I.e., here we publish ->tfm with a RELEASE barrier so that
-	 * concurrent tasks can ACQUIRE it.  Note that this concurrency is only
-	 * possible for per-mode keys, not for per-file keys.
-	 */
-	smp_store_release(&prep_key->tfm, tfm);
-	return 0;
+	return fscrypt_prepare_software_key(prep_key, raw_key, ci);
 }
 
 /* Destroy a crypto transform object and/or blk-crypto key. */
@@ -190,6 +195,20 @@ int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
 	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
 }
 
+static int
+fscrypt_prepare_inline_crypt_and_software_key(struct fscrypt_prepared_key *prep_key,
+					      const u8 *raw_key,
+					      const struct fscrypt_inode_info *ci)
+{
+	int err;
+
+	err = fscrypt_prepare_software_key(prep_key, raw_key, ci);
+	if (err)
+		return err;
+	return fscrypt_prepare_inline_crypt_key(prep_key, raw_key,
+					       ci->ci_mode->keysize, false, ci);
+}
+
 static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 				  struct fscrypt_master_key *mk,
 				  struct fscrypt_prepared_key *keys,
@@ -255,7 +274,16 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 	}
 	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context, hkdf_info,
 			    hkdf_infolen, mode_key, mode->keysize);
-	err = fscrypt_prepare_key(prep_key, mode_key, ci);
+	if (!use_hw_wrapped_key && fscrypt_using_inline_encryption(ci)) {
+		/*
+		 * Filesystem-managed regions such as F2FS inline_data need the
+		 * same contents key as a software tfm.
+		 */
+		err = fscrypt_prepare_inline_crypt_and_software_key(prep_key,
+								    mode_key, ci);
+	} else {
+		err = fscrypt_prepare_key(prep_key, mode_key, ci);
+	}
 	memzero_explicit(mode_key, mode->keysize);
 	if (err)
 		goto out_unlock;
@@ -381,6 +409,7 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 		   FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
 		err = fscrypt_setup_iv_ino_lblk_32_key(ci, mk);
 	} else {
+		struct fscrypt_prepared_key *prep_key = &ci->ci_enc_key;
 		u8 derived_key[FSCRYPT_MAX_RAW_KEY_SIZE];
 
 		fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
@@ -388,6 +417,8 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
 				    ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
 				    derived_key, ci->ci_mode->keysize);
 		err = fscrypt_set_per_file_enc_key(ci, derived_key);
+		if (!err && fscrypt_using_inline_encryption(ci))
+			err = fscrypt_prepare_software_key(prep_key, derived_key, ci);
 		memzero_explicit(derived_key, ci->ci_mode->keysize);
 	}
 	if (err)
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 54712ec61ffb..3762a7526fcc 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -346,12 +346,20 @@ void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
 struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags);
+
+int fscrypt_encrypt_data_unit_inplace(const struct inode *inode,
+				      struct page *page, unsigned int len,
+				      unsigned int offs, u64 index);
+bool fscrypt_inode_supports_data_unit_inplace(const struct inode *inode);
 int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
 
 int fscrypt_decrypt_pagecache_blocks(struct folio *folio, size_t len,
 				     size_t offs);
+int fscrypt_decrypt_data_unit_inplace(const struct inode *inode,
+				      struct page *page, unsigned int len,
+				      unsigned int offs, u64 index);
 int fscrypt_decrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
@@ -519,6 +527,19 @@ static inline struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 	return ERR_PTR(-EOPNOTSUPP);
 }
 
+static inline int fscrypt_encrypt_data_unit_inplace(const struct inode *inode,
+						    struct page *page, unsigned int len,
+						    unsigned int offs, u64 index)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline bool
+fscrypt_inode_supports_data_unit_inplace(const struct inode *inode)
+{
+	return false;
+}
+
 static inline int fscrypt_encrypt_block_inplace(const struct inode *inode,
 						struct page *page,
 						unsigned int len,
@@ -533,6 +554,13 @@ static inline int fscrypt_decrypt_pagecache_blocks(struct folio *folio,
 	return -EOPNOTSUPP;
 }
 
+static inline int fscrypt_decrypt_data_unit_inplace(const struct inode *inode,
+						    struct page *page, unsigned int len,
+						    unsigned int offs, u64 index)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int fscrypt_decrypt_block_inplace(const struct inode *inode,
 						struct page *page,
 						unsigned int len,
-- 
2.34.1

