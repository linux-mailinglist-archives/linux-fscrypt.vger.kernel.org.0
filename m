Return-Path: <linux-fscrypt+bounces-774-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58ACBB1936B
	for <lists+linux-fscrypt@lfdr.de>; Sun,  3 Aug 2025 12:23:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EA8717277E
	for <lists+linux-fscrypt@lfdr.de>; Sun,  3 Aug 2025 10:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA8C288519;
	Sun,  3 Aug 2025 10:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="hRkYvFFb"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012038.outbound.protection.outlook.com [52.101.126.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AAE2882D2;
	Sun,  3 Aug 2025 10:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.38
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754216587; cv=fail; b=cReIUktJVfdHQHeFCRBd4KO0sYv0pfADITVGX6oQTwmkv7afpuwFHf6ffaOL/ZUI5jexQAXd1xQIRmiM+mL5lXwkgGTITFouvCrrOHNgcTqMfFbtuA/wGjOuHc3/0rp83DZouZZOc0ZFmXqEzYYUq/AZupJIWy0sh5YwT29w9js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754216587; c=relaxed/simple;
	bh=BqQHAqCRRm035h/nyL7MYXAN2nAHCLXvrjgh04t/Sh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OHJcOJuA4rkmwrHJs4NnW/B4cgW91PV/t7iPLjJvJSC/h15YvLvyYwtFJYL9I5KnykXBr+wroKTBfCFQVCYWqQHhM3qwpwHI5HUUJx7bhxtPs0gRHWYIkNChO2QtraBWGSghA9LHf1NHro+7z2x7ipEbx1sdRbe71+fchGhCsVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=hRkYvFFb; arc=fail smtp.client-ip=52.101.126.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hu/hzGCtruIGe4AkPiG1ye3940pJaawsNZb5Y+hOTlQdTutjOWSdmV8n0R27dDMjjq6lOyqxfMq0tpFjxAqCfFXqM5LPWNt/eZohIDqABSzib7ENkkJgzoCFTQ2ilg4jCysGH3ZN+sHb5LbGBHp9CTE6B1SF9isz+yHRMCiPVOLhHvnZ45pdjvVbCh+q69U8lCGpTRNbfCaAtI2h0F6Zfxce+rzr8vP9uX3EIXE37rXCwwtepNfdz9KtkwcLJzdFYKUKElWhr/pc4XKjKRZeNdoPvXceIO3RZHzrUEi3I65MI/RCbtI3esIg4mkyqZp6GDJM40PMrDsXD3ZonI5n9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lg2sRffZGxj0VOX7K25T01UCYCPRZKhBdEr5k6P0GVo=;
 b=jc/SVe7Hqxfq6gVHiVWThY2CwvasUbB5XIE4UtSLlbeUO7aIxB+R84pgoFHWZyKnFq6Wb+++ov/UN9p6LmbMeM0apsFhiIzv0ClQY/2T6vS+TAMFXKg/rWZsI79Gieas49mbVfeQTjGXAext1fcey+36x5lsk9MM4goaXq2a2pIYh2bpW8PWjEVDjzU0DMRK1bwv0sECS65cDETkhUpCLAFMq7xp4cBUPBsBgmM06w+2pH1fXR6a8ndqMkRMp9/UftgJcXVmgx4hI1W89NZIKWZV4YAK/bGFdKJnY21LLqwGUEOQHKyIYaeEeZTn8sdMu5ikY2POzuhRFDxQL+uEpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lg2sRffZGxj0VOX7K25T01UCYCPRZKhBdEr5k6P0GVo=;
 b=hRkYvFFbnOkIBziXgKXvkRwbOD45TvA9s2YsIgjXiLMbUqTk8paOC/8GcNkcJP8k2Q3YTxretxaQKXXaF+5ac2cLwp/wr9BRe/7zuSxxzvSa27NXW7HS4agorjWzXJNr4U45iguJUsqpq8t1RfizISAoOpXo8jVbFK17gYpcLb7QqrT2s9+58rafTNQUvfduJqh2LWFkDhIGGFGYs9cqyK/xch6p9xlNpHiFzltkpqNfgvE7hDT3OG1aVxtLgogttq6tWFR7jmieNKmpFxPAtijIRwb15ufXPzzoqwDR3rHmMWm1VAIO0rdsJT/keHhDja/7pBvAi3+3ECiNa1ibkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com (2603:1096:4:1af::9) by
 TY0PR06MB5128.apcprd06.prod.outlook.com (2603:1096:400:1b3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.18; Sun, 3 Aug 2025 10:23:03 +0000
Received: from SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666]) by SI2PR06MB5140.apcprd06.prod.outlook.com
 ([fe80::468a:88be:bec:666%4]) with mapi id 15.20.8989.017; Sun, 3 Aug 2025
 10:23:03 +0000
From: Qianfeng Rong <rongqianfeng@vivo.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org (open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: willy@infradead.org,
	Qianfeng Rong <rongqianfeng@vivo.com>
Subject: [PATCH 2/4] fscrypto: Remove redundant __GFP_NOWARN
Date: Sun,  3 Aug 2025 18:22:40 +0800
Message-Id: <20250803102243.623705-3-rongqianfeng@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250803102243.623705-1-rongqianfeng@vivo.com>
References: <20250803102243.623705-1-rongqianfeng@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0002.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::14) To SI2PR06MB5140.apcprd06.prod.outlook.com
 (2603:1096:4:1af::9)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR06MB5140:EE_|TY0PR06MB5128:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c7dd092-1173-4b25-1971-08ddd277bab1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0Ei0mMEGt7TlQPQPWSLfiXmuLz/krbfkJQ8pe8drtZ7v0DX2hJZFZJOaqZ/?=
 =?us-ascii?Q?fNBO7BALyD3DOtm++SfeaU4eO4IrrpBZKvS7bmK9he4TGRvr3B7BbvxgFW/Y?=
 =?us-ascii?Q?WGW2iYiWheHYF8ovRySQ7FfeHIZz86DHxIKPGnni6MCxdKFY/MRr4jkKoefA?=
 =?us-ascii?Q?GdHf8JaL5JNb8SwBOcjr9/Cjd7l9etrM+0ajcGh0wVku4V532xYYTDqIEzqw?=
 =?us-ascii?Q?agQAXeDJ8of0Qtz713Fd1sQzNJ2viHAtAlel0B7BpCTmjWckfugYwDk++fiD?=
 =?us-ascii?Q?TzpCMSVQvkeSePavy4tRxiigaUgsb4D9UTmqlStXmP9yLVaHsvDVZuq+hEMa?=
 =?us-ascii?Q?nUcTbbRqFTKWx3im8LmCp/ol7L+EpeLv7XcmEwnxIX8SLQjAXg/lKyoVNgJb?=
 =?us-ascii?Q?/k8SnfZ/BZJv+iin4DInew1wmsvx4GmT9G/F5sWmAACcmqj9Q+NBk3fX2iIH?=
 =?us-ascii?Q?TgBjLep35b5vZAotBg4lsig9DtMX3yezwWEVMAr5L41Jy/iPBhZ9zRISZyVc?=
 =?us-ascii?Q?k24LHGsrZoPitWwQszA1BTVY3MPuLQJqcPNE+ZdEc9PP/dz7UfO+htsN4+2u?=
 =?us-ascii?Q?lv08BmzYKZh/OlQeyz5iBfXVQSi+acxm5dYRNL+A+tfvSj/OZw6kRhCMyGNT?=
 =?us-ascii?Q?GEVstgwzR4Tt4xZeoxttTJa0k50bcPHR9AoltBg8JVw4PYQtqm7gDTJp4R+O?=
 =?us-ascii?Q?f8YA6FlkvFxL3QJtemiT+3GpfcyxGDPTGWvZQOlg8EJETu6k+RlYwG2fIthG?=
 =?us-ascii?Q?YN5f+svjhlb13vGie4syxdBKoDroecF2ygJ9ykfGq01V5YZD3N4Xb4LatV+1?=
 =?us-ascii?Q?qegwMg8r7t1WGYkUfFaVt7kJDMgy1YAE9CJAHLpFq/dBxcxZ144dZ/wZNmTN?=
 =?us-ascii?Q?jNop/BnOD7Xs6YbG5kXbbvoJlh1YGWjGsd5Oe560b/JceAtBQObRZjSCeL1a?=
 =?us-ascii?Q?14Z+LAo8t9z40Pi0+oKY9qZcU5/ZIG8AMKsBsxdlD/sos3l2MGCGK7zB4U5U?=
 =?us-ascii?Q?Avsv3+aURN1xxE1S7zmhPyV8skuZb1hpa2yuPnBP7J3IqYOvoQXlYkaay2U3?=
 =?us-ascii?Q?yYX5b50XRghEClULDVgWIo9SFhISV3/B+fyzwChxqrqjH2Hs9lV6ME1dxvuI?=
 =?us-ascii?Q?AD2abunvWBZBnlA2f3QatgXocNxZf312w/uOucGmRB6bP8dofHOUg3IBYZoE?=
 =?us-ascii?Q?UaOhEBCBZCOVToH3PF7tbO4UIXa84CabO3X1EHLpaiWECCKEC6z3siyfuJ/x?=
 =?us-ascii?Q?BbtprGxkg/jE7BRS4DtqDYUTcRvEdUA00KS4KfbfRLRTvZxefbm+Dg0cGPTJ?=
 =?us-ascii?Q?ZlH8rXXvQd2h5rxqXXgEFNb21wieRmFnMCKYEY64FdEU+nENq6Gk0EOxycaC?=
 =?us-ascii?Q?p2FkLAKFNXT8oriaTskTVYEkIIorYgRv2I/3eiA4UvKTtjkigMF53W9wkXU7?=
 =?us-ascii?Q?y7ZZpvY2aJXieDSeR7dv7OkT/+rsK6XNUpr+0bokCjS0WthyPgWTuw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2PR06MB5140.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(52116014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Psj8bDkuqlogpwFWXL5UOWV/cjz0Do3K5wSysmOnUsSQ7Q7QcjREo3N5p5Q3?=
 =?us-ascii?Q?3Ta5j9rBwtEVZzeOHSw7gssrPECxo/gMeYfcWrUHgFWRAEYjr71Ipj6+w5fp?=
 =?us-ascii?Q?yWM3ZHLT6ODZNUlgxrkK/zyMUb1GCre/ZYXZeWv/NzyD4t3lAj7z9SUtMFm8?=
 =?us-ascii?Q?U4XIeoP5qOyK3Js3VQHdrQ4LYwIv/KBpxp1BB84JaxoqXRvT3DWCxvjFjvQW?=
 =?us-ascii?Q?MRYabkmRUtjkNPPlnbi2XvNPldxuwG3IgTQZlkVrVoSI/TUb0tfU6G6v+jIl?=
 =?us-ascii?Q?Zl8en6AL20/iZCaI6FMy6u32fOELPm+5IaaI6t+2mZYCgA0PeTyQAhL5Gksy?=
 =?us-ascii?Q?GcPXtQnxWPBIpgidXo6d1Kl9y4PrwISzzb2NC/bilCwxgUd+B4rXPBKwnSYG?=
 =?us-ascii?Q?o572PFyUuQMP8eeH8Kh3f/oONtMh/TPmMbmGGEl0kuIWKLEDHmRAve7P/ues?=
 =?us-ascii?Q?zo6T9htyuckqIWFnKoDiBNuGqBug7iLFqJoBLQcQRLqoTXiH68qDx3CZkL+P?=
 =?us-ascii?Q?OceKCOXQhfINwvz7xKmkgd9uUkGETLMG5/OWWRDRaWAHXi0VX4M2Q7eHd+MO?=
 =?us-ascii?Q?W6J/FKdq6v0oFZlx0y021n5Rz0M4QbMs2lJRSTSIFVyeh6wGClfvx3MPoTKo?=
 =?us-ascii?Q?O7NIUyx3MhzcbDfPr8fVXFLk/nmHBYpXIzJrAO3RW+Z5eC05g/OKCsvo4FiZ?=
 =?us-ascii?Q?/wgdHjwK2Cr8Ji/bkWv6fUuUdNISsOn1Nlb0swX26YN7aQPkwSfCi0Z3eM1C?=
 =?us-ascii?Q?0g4LVrtOXuzZgto0f3kGTgmfAXbhGyxzp0CkOQ6eH0d02fKSvEk6OSIXaVuy?=
 =?us-ascii?Q?vrUtzxF/5doqSj/MESQ7exCZgMKQmjyqEJFEaAa/O694BAMSgpVhTWs4VuMb?=
 =?us-ascii?Q?TAn5UtT5uteZ+FpKxTcuS803qCL7eDkKduPfmyi5W6u9fX4inUy9YNdn21k4?=
 =?us-ascii?Q?W6f647DyhjedhqNhMmyLSqpXsE5/dkyWR+/wn9/1o27jLUG29qjQUPLM86Yz?=
 =?us-ascii?Q?8HUPSNNKo044GfWaPkEN71d/Bn5368Yiz9HJzt7YpMync0ADRWFxVT2uM0vN?=
 =?us-ascii?Q?XAYce5OufqiwOBYf6JRtLp0XjE1wNg8YtkjrZvro4dHnv12/WkxnLlzEt6n+?=
 =?us-ascii?Q?Ru/CwAXxepCCOU0YxZQau/+y18gM9DBzzlrOiTzFdpAkAcwQIgSt7gwHjGby?=
 =?us-ascii?Q?5v//jgWEy/xE/Sv4xxfsm/s0BBG/qWtqKNcjuGl3pqEHZMvJG9ORtw/sku9K?=
 =?us-ascii?Q?5q3ssuSClcwaNQVUqPZZRGecSR4z46gWtqqqDEu7oRRHeD5jdOAJ6Ofa25b+?=
 =?us-ascii?Q?i7Bn9UZ+eOiDwT1tqzmaJZoUuc2pZ5bds4amSPMiuSdEw9E9n8YR9GS/nbVP?=
 =?us-ascii?Q?KO3EBklPDipNdehH7geaoE3D7qbKANZRD/Es6D5521FMP1COxE1V77QcDejG?=
 =?us-ascii?Q?5MNr8yjbzeUdooztFZHe60UQT+Mkns4K/iKDBV4nk2k84RwxJCv4uDhG4hio?=
 =?us-ascii?Q?3hhpQTqY+7jKkBxM/ant0FtPfO88mobtdyAyh7vI926L0qxX/nqH0MZ/epQo?=
 =?us-ascii?Q?9bI+ZG9ItCif4PAjtUjOJgPX9DvKyryk1OT+wGmY?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c7dd092-1173-4b25-1971-08ddd277bab1
X-MS-Exchange-CrossTenant-AuthSource: SI2PR06MB5140.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2025 10:23:03.4017
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZQocuHkKO8RX6cfHE7ayH/SvQFXNWNISf2S2C3yzsufztATSDV+nzd3KOkDDT2N6UaGqXJh7A1rlgqkMxprOqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR06MB5128

GFP_NOWAIT already includes __GFP_NOWARN, so let's remove
the redundant __GFP_NOWARN.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
---
 fs/crypto/bio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/crypto/bio.c b/fs/crypto/bio.c
index 486fcb2ecf13..e92967e20e2a 100644
--- a/fs/crypto/bio.c
+++ b/fs/crypto/bio.c
@@ -148,7 +148,7 @@ int fscrypt_zeroout_range(const struct inode *inode, pgoff_t lblk,
 	 */
 	for (i = 0; i < nr_pages; i++) {
 		pages[i] = fscrypt_alloc_bounce_page(i == 0 ? GFP_NOFS :
-						     GFP_NOWAIT | __GFP_NOWARN);
+						     GFP_NOWAIT);
 		if (!pages[i])
 			break;
 	}
-- 
2.34.1


