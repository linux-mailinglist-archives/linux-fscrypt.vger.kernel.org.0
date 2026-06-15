Return-Path: <linux-fscrypt+bounces-1637-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id bVz8EVr2L2rXKAUAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1637-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 14:55:54 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B0264686718
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 14:55:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=pLBefK0K;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1637-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1637-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F040C3035882
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jun 2026 12:55:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A043EFFAC;
	Mon, 15 Jun 2026 12:55:34 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013023.outbound.protection.outlook.com [52.101.127.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D4B3F0AA9;
	Mon, 15 Jun 2026 12:55:32 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781528134; cv=fail; b=SwgAxgeFof2u33CYM1uH8pWsFr50IfsBS0ySufyVQVUJhuXs+kCQDdJYIQ9NAWEC2Am2xXOvwiIC76DgyOxltPWVokZnnaki8HCNiokDIyuUQvgK0LIGrN5yZuVnglbxvH1K5W9woV57xw2zzq4poK1ao8giI0dJD2/kb/IQfyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781528134; c=relaxed/simple;
	bh=/dU8USVHM0SaYTtMnxyoBQcQTlrUzaDvsbIi9Z5YQ7s=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=TIKTlN4dALdeF8YEDl33EBK62WOOqaZGSVL/bA9kFrC6DlyDBYbYk7MGdP6moGmuxHD6P1ij/F9arjWBc0AaK0557faPrgynkyY3mPhzuKT8exnSQMmTggMzAFFIJDSXo/rDODYvBqMtvQG34jm5d81b0Wmq9LIMxrTVs0NrGR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=pLBefK0K; arc=fail smtp.client-ip=52.101.127.23
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Of/NnTTCnbRichTByrl5oMDBTNp1NZgVcdNGK2GTGm3lH0KmsWtC1867OO8f/76+7aybyHxJJJWn99wKv8rrosEMwWiOVKZTkKXDD7ZVTQzYiZkNJtYUQNPA9nqLQZvEOZ36H8Z12wKfWux+c2pZoaD8JqFfxn7+RtGa+1zMjtsU3coVWYnTWMmoz/izBNfHH4zwhsdGAd5IIxMhkZdmnV+/gbqM+hwzrCrazDIQMEjGHXz69hv1MwptjaoyYIRcszdJgUPGB5B/EiJI9dIrZMs43US7mzompG5GkfX2/bs5hxMQOj50WWs053IDBBZTZJHBubGPWf4cZM2CrzDq7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kdeb+GboxiNNfknkb03jWdO2NoaP9Lcu6b7fz8YCvTA=;
 b=Jyf7zZqkVrxEbX0Scmm1+XO19g6Alw5syHS9r4W/TY7dHrzRgNhkgxSosCgpSy62dCzwjuTl2xuLl6lS/PJLt/GWztFaLH3CMbO6XxcfRacgl+K9kK10yh8bc31RFW3feWLLWJBBrnLEEP6G9CBZXs0Rmr9DxZIHmY9yB0mT8V57P0gEGCqf3rTYIXCFnYW0R7XPk7ie/+KlMQ51jNdUskAriQmkJbM3/Ssi7JZ+HE+xOwZ96ZhdB1z21opZ4G/GoHNHcpTkMDK5mnQ3fKobTitmDxtID1RrTLzouHRT7gpO9QCYswuu7x8cY3CyiR2Z6HNr4/4hroI6t3uM+t+orQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kdeb+GboxiNNfknkb03jWdO2NoaP9Lcu6b7fz8YCvTA=;
 b=pLBefK0K+09LkyZsNrZn718gwvWgI/t8bLKkLvEc3p2KtMKiFjrvqSdnN6MFz6B3JZsvSmaviFyQu2DyAR6VS4ZlZ/59lrJf8K9LDxZArDO84r/DBaTI+36WVtWQcGH1VNMSimu4I6W+hysTXw+Wq8TUZt86NBlCBbpb3sJX4CdHpyc+1dOw22uW05ap7+Z8EBQgM32Zk6t9LIaNd0b+/FfpctTbrWgmbRecbe2Ig1N8l+4qrsxpPzKmq7Xm26JmVqNrkaVCLrajzAm9qiyIHVgXUexQo1lc93+UMiaI07e6QVfaY24lHSTvoj1cCKjndqd/I9OPon3qmqrDT7/wFg==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by OSNPR06MB8687.apcprd06.prod.outlook.com (2603:1096:604:493::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.18; Mon, 15 Jun
 2026 12:55:29 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0113.015; Mon, 15 Jun 2026
 12:55:28 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	linux-f2fs-devel@lists.sourceforge.net (open list:F2FS FILE SYSTEM),
	linux-kernel@vger.kernel.org (open list),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION),
	linux-fscrypt@vger.kernel.org (open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT)
Cc: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Subject: [PATCH v3 0/3] f2fs: support encrypted inline data
Date: Mon, 15 Jun 2026 20:55:12 +0800
Message-Id: <20260615125517.362294-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 45ae7e33-9c3f-40ef-60db-08decadd6053
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|52116014|376014|23010399003|1800799024|56012099006|11063799006|6133799003|18002099003|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	ebslDmXRpUwWkHedWADOVzCq8W86S9Vui7jotJANVntyPOxUbaGjeEIYimjXsgwwVElxM35Ppvyr0iohgYxmVMTTc01IL8HiI+hL1IM0h3Z+0aWPJ8qMqCDspWx8b7RUC/Jtrqi0L3VP6EDntr+SmmAb/6U8khbRvd/Hg9oSaBA3OH1wRJk5p/Soh1if8oRNL7vZQpuYJcuNyk8UZBAZDeQsOCsuhwi6wvQtooFopc9qm8JDQKvZzB4XtVFP4djSUuY+Q6TjUtuxyGKm3cuJTvQQBjCbME6AQhuvts6ePTghS30Xqn81B0atmb6NkAehqHecYYbDWh0WZxkc4aG1WCIwHY3+mfzz4dMwEVh9/ARaPc/hrl8z6sdLigFbmI0QjfHT/NAhUZsU8VyZzia9k6SiVNzL1UV2AEMzbGgaudbUYQQFRPQ11TODvCn8IkuXIrG31uUXAcoZEeyNwem7P2sIos0XsebFk3BKrAT7fDJsZ+VoVA6QGuiWdhXw2s+HWJWGV0aXAAlPXQTXdt/Pa7diH5VDvbH1TF1HsBIxSfinXaoqUtCsSz5Y5zP/GTP+BVaq70f7VGAGHDxg71/0VRYkgX4YpygauJmrhf9bGeXgfWNKXr6QYY3lilqCztOTerDmJxSltGdZnOt0hyeBWxqexJRumOgDHsvs2mzNXYOsdM+PqI/cpkRBJHx7DlNqlFESrGrrxiqDF0Po5YVFa9JFZFTZCvoRSKYmvDE5kQYXkV9kyOtp4cQKNzh5ZaPvQnrgNfomLAacNVJZsPf5tA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(52116014)(376014)(23010399003)(1800799024)(56012099006)(11063799006)(6133799003)(18002099003)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TbJq+x1fXPftDe7BjtYZvVqGpGsZJQ2rd9bmKmDRxNITzJQzjnXutLRP1GsZ?=
 =?us-ascii?Q?oo8R31OtpjePUbNN6ukCdsHknw0Y+N/Db6n4ZiTNLLREKbDzZ6wMu6r8FTP5?=
 =?us-ascii?Q?xpJzZpqMd6k7qU65YdYWqLFHhCnErEQjTtO7woYcIAwNF4PrYLVcGifIOLjA?=
 =?us-ascii?Q?JigyiutTwNzwojTeemHvkGqvoq+AxZDiJ4bMo4TXgdA4Nesq93GpXvYHGDnD?=
 =?us-ascii?Q?JLLMBdakEHkDKob+b0R1PGs27rDDWqU8pneEkXQh6zNXoNdis1ObTAP24Omw?=
 =?us-ascii?Q?/jbRNbeoyQYM2Rk9aZjzbQ9zFoYywPmHKSZnvblbymIe6I1sXG19oNoYT0T7?=
 =?us-ascii?Q?Wz/+nPXpSkSbwOcQykaLCqJRLAGs84AiGV20pDtCMnBFwE33S5f7CphbaBqH?=
 =?us-ascii?Q?8szIvF7MRKHKoPSZzm/J7Kq5Y7n7MUXLh2nYOtbZJLIgkeZ6Tkdt8kEFttrB?=
 =?us-ascii?Q?SZ7nuT1O8KAzCo/wp7UugJapdRuWeu3lWRo7Ava2JPZisZnSfpAowvsVnkOA?=
 =?us-ascii?Q?lNXsAnx8+YG5uZhIpWUUJyASFsGWzQuBErFRVqTgO6pJUjf0peR3I0WQr1IS?=
 =?us-ascii?Q?7UufVcQo3tMdVhxnzR1bzGVoZuo406crT6bMon1I5xnCoCWh6+jcSCUBRaLO?=
 =?us-ascii?Q?i/XsikIruaE+0xJvSBJBgxSshMXx1KT5PGRKPoUbuCfKW9LSdgvt4I3wAaX+?=
 =?us-ascii?Q?mOjDgWt4EuO1N3xXM3uaQ+CtEh1CCKaVhD32C5a7bTBBQcQLj6OIy0xATDIA?=
 =?us-ascii?Q?cJxUIAzMoiU+hRe75huvw+YnRGJsFFLxIpTRqqjx1dy+qE8dneusWTVMyRha?=
 =?us-ascii?Q?7SyjkLQEk1a18OhBv/Kwzi5il7tEgXQsLy1XsTTrPrmSL26wtrND0Yau6LDI?=
 =?us-ascii?Q?lSh/vqb3IAUQ7KCVwrkdpvsTfDuB45t/rD1GC2QFJ8Ksm8p7Dl/ZtLqJvBVo?=
 =?us-ascii?Q?FSbEX3ybO7e3Sl+fKoyhut2QNHm8Msjqt0MDlR2LQBFAQi2UZpg8y47r3abI?=
 =?us-ascii?Q?pza1k48ciIHW1f4z7bJ0Sis+AGtuzRQBW41Rcgx1BSADaMp5VK9eDg+tedZz?=
 =?us-ascii?Q?a5Fb9fwQBYoRDnvtQwnOCD7MKh2p+ua0DNnkb2MJqJzZyGL7gGmfr9nfHyeY?=
 =?us-ascii?Q?LMJ3jHx9y3e63/KtIIobVecS5m/mBGWv4HenpkENnPykrrQ2ciaM57sjLXup?=
 =?us-ascii?Q?hrQrCZKoE2JhJ8WLYbUpheBVPIU6LeCNRwrsToTnijI5fCIOsuMEwFAHSL57?=
 =?us-ascii?Q?fBqrDGxt0Ij++H3HMpquWEgCgu3ZLJgqnJQ03E0H0kCOI432Rqm3NQuixRlt?=
 =?us-ascii?Q?IpZsxIksWPZPCDYFHslhhLj6rWgy8gYDqdA2oEgTHNxRh6ojhJ6h0xNNN3M6?=
 =?us-ascii?Q?eBIaSMd040MNF5JWf+r0RDLnqZpx17svLEgwEmX4Hye91U0vLi9qic6Q7Av3?=
 =?us-ascii?Q?CUsBsIxv4K4LcE79TidCM5L9X3R4a7W2Cqne5TEBwHRBr4e0FgAnMgsQdROF?=
 =?us-ascii?Q?yi9Ls/gIuCbSLaiYBtD48f/NJC0YCtz/Ua29PRz7Q/L73NGzZ/sEEVdTuXB7?=
 =?us-ascii?Q?Sm1gkegWuedCY0gw6CJfc7P7rvT36SONSD43diWirum2wuH9awU0GROEyprh?=
 =?us-ascii?Q?qagDSarxAisv0foWYDduq6zKoWtFZ5dm6mwGlA7FqTsL8wuMhE0g9pfn70iW?=
 =?us-ascii?Q?9pI7uCg/JHTdzrR9d4zAVI/oZMg1RNqmo2qWMENzlmRY/6maX5VrGVJv9atp?=
 =?us-ascii?Q?5af4Omebww=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45ae7e33-9c3f-40ef-60db-08decadd6053
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2026 12:55:28.7455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aK+O1Mtq6k+WsK5ozche+pbwSIyxJ+afcAQmROWoGsejTbs9kBXh1ERYM8Ylzeje8m6L49D1O1kZd2smevcPTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSNPR06MB8687
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1637-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:jaegeuk@kernel.org,m:chao@kernel.org,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:ebiggers@kernel.org,m:tytso@mit.edu,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-kernel@vger.kernel.org,m:linux-doc@vger.kernel.org,m:linux-fscrypt@vger.kernel.org,m:liaoyuanhong@vivo.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,vivo.com:dkim,vivo.com:mid,vivo.com:from_mime,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B0264686718

F2FS currently disables inline data for encrypted regular files because the
inline payload is stored in the inode block and does not go through the
regular bio-based fscrypt path.  This wastes space for small encrypted
files on Android devices using F2FS inlinecrypt.

This series adds an encrypted_inline_data on-disk feature for F2FS.
With this feature enabled, encrypted regular files may keep small contents
in the inode block.  The inline payload is encrypted before being stored in
the inode and decrypted back into page-cache plaintext on read.

The fscrypt changes are scoped to filesystem-managed data-unit crypto.
F2FS first asks fscrypt whether the inode's key/policy supports this path.
It prepares the software transform only when encrypted inline payloads are
read or written.  Inlinecrypt support is limited to v2 IV_INO_LBLK_64 and
IV_INO_LBLK_32 policies, including the hardware-wrapped key configurations
supported by fscrypt.  Per-file inlinecrypt keys and DIRECT_KEY policies
are not supported for encrypted inline data.

The basic encrypted inline-data tests pass.  The test creates encrypted
small files and verifies that they retain inline data.  It also checks
normal read/write correctness and confirms from the raw inode block that
the inline payload does not contain plaintext.

Changes in v3:
- Support fscrypt's v2 IV_INO_LBLK_64/32 hardware-wrapped key
  configurations.
- Drop DIRECT_KEY support for encrypted inline data.
- Refresh comments and documentation for the updated key support matrix.

LiaoYuanhong-vivo (3):
  fscrypt: prepare software keys for filesystem-managed data units
  f2fs: support encrypted inline data
  Documentation: f2fs: document encrypted inline data

 Documentation/ABI/testing/sysfs-fs-f2fs |   5 +-
 Documentation/filesystems/f2fs.rst      |  30 ++++
 fs/crypto/crypto.c                      |  47 +++++++
 fs/crypto/fscrypt_private.h             |   3 +-
 fs/crypto/keysetup.c                    | 174 ++++++++++++++++++++++++
 fs/f2fs/Kconfig                         |  14 ++
 fs/f2fs/data.c                          |   8 +-
 fs/f2fs/f2fs.h                          |  37 ++++-
 fs/f2fs/file.c                          |  24 +++-
 fs/f2fs/inline.c                        | 134 ++++++++++++++++--
 fs/f2fs/super.c                         |  12 ++
 fs/f2fs/sysfs.c                         |   8 ++
 include/linux/fscrypt.h                 |  24 ++++
 13 files changed, 497 insertions(+), 23 deletions(-)

-- 
2.34.1

