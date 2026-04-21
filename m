Return-Path: <linux-fscrypt+bounces-1551-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6C/TKJIu52mf5AEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1551-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2026 10:00:18 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 07327437E98
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2026 10:00:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2CFCC300E634
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Apr 2026 08:00:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0D0337EFEE;
	Tue, 21 Apr 2026 08:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="mvDhpkN8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazon11013024.outbound.protection.outlook.com [40.107.44.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D4B5384246;
	Tue, 21 Apr 2026 08:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.44.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776758408; cv=fail; b=A+Hc6JXo1trV7FK3FMfNtlZFLap38OvGjV9qUAJ251+RlqzJe5ajFRRlLKmYRgyzcXN0VatP9cfut9LyCEgvnDP9hIMuNGhFgunvDlZ0tQuYVAhAXdRZueU46w3E2mIVQOA2JGk4NdIcJYrGxJyo0zD4C7sYhPBXvBSlJvbkQ1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776758408; c=relaxed/simple;
	bh=APYArR3o4hgRL3D6hbinFTFhkrikY/zaKItJzN2GJzc=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=buFjgli4tbbpuXNUzkK7ez/DynOAqkmRRbK/TqqpiKoVkAO61LFlCMgLogeEhKFONJRprl2RKzOxq89z/W8S2cvuubY20Jz0fo/T5jLNc8iYCSHi7+gjus7s1v1a/tTfrYdbTH6YTPxv/KwP4y4wmhAtOGqkiJeF7M5Guus6DOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=mvDhpkN8; arc=fail smtp.client-ip=40.107.44.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JEiWVEVEIIjG9P0ydqe25AmSJozo0C8pWqDidOcWQaW8BN4geMnbtY2fWFFMQSQjosuUPi+lHBHwLqoLnLX66KZWKo6qK7JsMnwtpcOqHOiW68VnC4aVCptZltJPLlkjgr+8Nx6w8+d7c9d4qVHRUjT+UqTGjjAQ+Evp+xCQfxufcISkafwsWjdDbxVuH4YxgC936gv/qkk+nUejfPVcmRDML0kIIJMyQbP8OvTeGvTOvh1lCwdj7y16g7ZxhYBkw1HdM9gaxKCKT9gfpwxsFtarKVrxgwDNJRu2zUVc4AMkuesPogRWZWJ/v5oCLSzfBwiSaeADklEsCIbJcMAQHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqZ3eQANTPFam3hjlUUvc6WkErJuExrr4+UH1fpgt/Q=;
 b=IS6K2/gc8TQvebCno5Efwc+bROf4bTZUwkc5Aljpt8aoKONxxjXTTQlykToLcw4TLKPgzLfG+dAZ4ciOqKLAMcxPhRr8P6KTTruX1iGIONhcty+LJ5lcnzEB9Bz0LSvJuIfJ1yY+FnAyQm/qRxiLQ3P4Yku5+RLIZFeZ4MZrYGCk19t969vv2r6L+BOuU3bPhcBPfNCrmuXlbEqGcYPZ3jb/zW6MQj2jhfOri77a/DiUWPnHKMbdrT6/CLIOKGrco/9cxcNjibFayVhZ63vkAjvI3fonJIFdi3sJltZpEHdr1QlFBozbOKv+TwW53rBcFugQHfZbeA+BQz/+YW8/mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rqZ3eQANTPFam3hjlUUvc6WkErJuExrr4+UH1fpgt/Q=;
 b=mvDhpkN8s6JJozNHEe2QoKcJOTZlLZA4eAU2dC1rTOc7x4So5cLVEWH9CwyUx+lzZxzr3cW+JCPOKFga289WGtxsM4PNi3aHBu/1W5vBoOXcIICpnFX8aKOQdzTZcPwLJ2sTad39qwlOKinJDyRrOHVNbFYqIHTFx4axZBHAgzztB+DB4xX5s8sGAmUoFZeD3m/kXAR96A7w64YaT9L/yKNQwUptVR76+xcoECAfkCIFAxOopOQnfEqykjjG3g1g7CLWub2OfMuwf55YlSE1+Oi9AQIeekQXKns+u4AoZUC0HH97GGc4AcxOGU5LpKbP7s0VTj3TE6aB2Y2vo8p6Qg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by SEYPR06MB6829.apcprd06.prod.outlook.com (2603:1096:101:1a7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.33; Tue, 21 Apr
 2026 07:59:59 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.20.9818.033; Tue, 21 Apr 2026
 07:59:59 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: ebiggers@kernel.org
Cc: tytso@mit.edu,
	jaegeuk@kernel.org,
	liaoyuanhong@vivo.com,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fscrypt: add software key support for filesystem-managed data
Date: Tue, 21 Apr 2026 15:57:17 +0800
Message-Id: <20260421075717.170840-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0054.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::18) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|SEYPR06MB6829:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b536c0f-c348-4d18-acb8-08de9f7bfbed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|52116014|1800799024|38350700014|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	23esdVWheb7XoeaBrKZZYPqGee0s9uZbeyg2+G4kLkzkv7+LrQ6bOQBEcJ+jpgVZbMCRE4VSzYcVqp3tWEKGaUmRO/vtDRt6S3W3A+9Enl6xuCQlMhRBdTG8oL7b01Z416ucqL26cXSlBoWW31PFVzE4kp7DQeLiLVNKJ3AQYBPt/g2LBmus5/juCF11qa+v+McPWdyoEL3fSubXuPS4j4g7XfsxkJggfVMjWKOrjBfjBI6ZmFJLCMg47KH11qRvzgUhZWTJN4Uh/zH/sXNstISmtWB9u5iDQkV32ugZz/TV1Oq7Qtgq1FnJpuXs3N4eLIjsO51T/Ci0Loy9iuYKwctcpVH4wmocZaL4KoyE2dp08i3F767bDTdfGfBVU6O4ztf7Gsb3W8HbkOu4g0CQoQoqDIXawQpqNOSD/ZOaxaSYc9kqQxATnfzFdkseg9NmZZ4Y7Z7kTHT5VzEjVtivBBBErH7alD5odLiAfU4eCGTKxzlaPfAf0lnH5ypBVqFyTBZFvuSFPqTlQNkpP0Rh8Gi6IpHhlyDHaDi8EQCzb4xUWW4hvyOuC9Yv2LDW1CCC0Yd32EwvJ5QwajMvoTjaEemaGFRMF2s4rP3BuMH3BsB3VayneK2KfjSxyAnsuaCjEdpfarogStJV82/Btim7+1Wk4oTKi6fETTtoDdUiDum3CcRgwZCessvWwgzAuo8CMa3c5iqOpT1/LYgD89/RG5Qc6DRdMNwLGLv5H30EvASfG6kCADAHyzxrmxwCWwcP98929VWJxux08/mb8GeDR6I5wsFXvXdIoSpTBv5rYpk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(52116014)(1800799024)(38350700014)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UjI9ESffM74EqwcRteCHx/VX0R/RxLv1rx2/0HPKbcXWCFa1be1GqKJkp0Ln?=
 =?us-ascii?Q?rE99yWsqbdx9Ew8xz0lJwU0/GTqTnM8AwAhLHpDkKmJFkJ4y5x+7zvAs8L0w?=
 =?us-ascii?Q?aR+uzLBHvNTcjV3nNYGGtwigN6qS47r/h3FB/IQi6uOnn9Bex06qQUrNgWx1?=
 =?us-ascii?Q?ZkOjkapVao8r4frdJkWJ2yFw5W/fN6hYoFmKpNBVUhYO7NCqZbvreknkM3/C?=
 =?us-ascii?Q?p/mnrSfBpo6JE8KS7XHxZIMpQ6aU8iddR5YbcBVYpsQc+e7M0SXwSkDMasAP?=
 =?us-ascii?Q?meqF9Z0BO5Mc/2oDOkCSuHvEUB3DXfh96SkTU7eDetOpFSIAcGQfkI6vK0Bf?=
 =?us-ascii?Q?fqu9NyeJg0a6YBBq5o2r2ZHsb92zbJCo4Nh8Ob6dFqKzVAwAmUqYvKCtECo9?=
 =?us-ascii?Q?EKAuGn/dy63YPjPJTCbGZqP5dh8DMip+OTFzgLqNQk2+0HMiFnHCPABSFioy?=
 =?us-ascii?Q?OIyK5dAgF0PfiCLBEDUwqGf6ekhJv2zeKiaxSwVRlmuWZ1+OBwmTUrQUO22T?=
 =?us-ascii?Q?34kK+24C4cA2JhyEhLf1sQye/HXLUCJIjfH/kV4Q5mPkpOfs+ErFC0q75bKU?=
 =?us-ascii?Q?pM3D1XhnrwZ+nUXU2CojAJ9yNpZ4l7Aef2qePGpuoEU6Q9LCcIEbbesGj0jx?=
 =?us-ascii?Q?EFzng42l9vrq1Ay8tWXQJJ9R8mlYNyhIcO/xym8NyQ1ZR29+jTCd5mLvfJxx?=
 =?us-ascii?Q?e6IUVq2o1hgir2tUcaM1QJocKYsIsc0/nhl3W0bmc7KNe3cPuc9yiDL/dd4/?=
 =?us-ascii?Q?QB4m4FG96JUmcRieORDYxzfnGD2xSLIMv0V0/fiTCCWVE+OLQgjMAg8UaGA4?=
 =?us-ascii?Q?1GRInH5+VdcjUOD6s0IgPkFeB0pjLaicbyUxR4vW3VlO+T3Xrhw0xL887mTL?=
 =?us-ascii?Q?d+fz65ocGceKHjgY71nYdAZgZ8saGfaMv1tbjpiF5Ey2IDGvUFocXzFTzhR+?=
 =?us-ascii?Q?rfJN1eIALrvWSUEoLfO2hyOSL18qNRZJ6WBkHUm9uZ/rfPv2DaftLTyeXHll?=
 =?us-ascii?Q?fcAi/6Nb8vUv2bWc/4eYT1e2Fr8//W8AVIGZrjwYdFxR/NQ2K03qMID0aEEi?=
 =?us-ascii?Q?U3mW+2RfqFIKALIyI0lUNm1+lUWAILkl/IVB5ge8IVLeEHYfMcV3qKJdFkJL?=
 =?us-ascii?Q?0Swfm5V/TDFOleCZ2iJ5qLShn6o00MvYUfP19JsJsdEHexsiVpj7GPa0ZJx7?=
 =?us-ascii?Q?rYT6LNfFGrF2Ot8as+dOwKyp5WHvIg3dvpfXc4AlLVcyYNE8R9MgbnpEkcQZ?=
 =?us-ascii?Q?bUaM3Ur1juuPAd6wpXnO1TgNaFmQiv31EvCWpjL+s35jnh1UCT2bFlEbsn48?=
 =?us-ascii?Q?rX5C+0dEHjDXMdZ+9g/HtxSv0j9El1uMat/uKIzkiFbsIgHjZqaTHZndQP/6?=
 =?us-ascii?Q?wjEQcTzEOYM4LY9q+3Q0qkbZlLwKpxu/wadaFMY9stOandSn+GM1dX3Ct8W0?=
 =?us-ascii?Q?QThaN1AOmfXoLWyf72Sv7lW1Mx5xvLjeLCLc1KZYc3929cI1hpqcCOMrvzEI?=
 =?us-ascii?Q?A5XeChS4TknO+lAsh/WkhqSme0pFRyxk5poxPwp50Ql8VCeRWbKIYKA0FSPR?=
 =?us-ascii?Q?JOeTTFlh0S9GAugUBdBWPFWJIEn0U5ULSURwDCiRjDI5+qM8fExUQuhNoOER?=
 =?us-ascii?Q?M412PUozG1qBH+N04m/mNE6UK6mMZgeQKXIYPgosdP6WUwDCOX8qSd+fpw9M?=
 =?us-ascii?Q?YYAQxRYfmYjBJmZzJdmXCoI0BK184HGN1PK5lbESsamRaN36Qra3jQEw/4u/?=
 =?us-ascii?Q?1JuhhsPZzg=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b536c0f-c348-4d18-acb8-08de9f7bfbed
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2026 07:59:59.2096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWmjIiZiDhsVEDiSIpX2U5gOlkTzA9qrJuWkol2HHCb/W08xLA3RPFVBmFxWEM3XLpiEwDJT//0JNRo0BkI0RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6829
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1551-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 07327437E98
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Some filesystems store small file contents in filesystem-managed regions
rather than in regular data blocks submitted through bios. One example is
F2FS inline_data, where the payload is stored inside the inode node block.
Such regions still need to follow the inode's fscrypt contents encryption
semantics, but they cannot rely on blk-crypto because they are not
submitted as standalone file data bios.

As a result, when blk-crypto is enabled, mechanisms such as inline_data are
typically disabled outright. However, it is desirable to re-enable such
space-saving features while still preserving the required encryption
semantics.

To support this, add fscrypt_crypt_fs_layer_page_inplace(), a helper that
encrypts or decrypts a caller-provided page region in place using
filesystem-layer software crypto and the inode's contents encryption
policy.

This support is limited to v2 encryption policies. v1 policies do not
provide the key setup model used here, so this path returns -EOPNOTSUPP for
v1. Hardware-wrapped keys are not supported either, since deriving a
software skcipher key requires software-accessible key material, which
conflicts with the hardware-wrapped key model.

When the inode's normal contents path uses blk-crypto, fscrypt may not have
a software skcipher key prepared for the inode contents key. Add an
optional filesystem-layer prepared key to fscrypt_inode_info. This key is
derived using the same v2 contents-encryption KDF as the normal contents
key, but is prepared as a software skcipher key and is used only by the new
filesystem-layer helper.

Signed-off-by: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
---
 fs/crypto/crypto.c          |  89 ++++++++++++++++++++++
 fs/crypto/fscrypt_private.h |  20 +++++
 fs/crypto/keysetup.c        | 143 ++++++++++++++++++++++++++++++++----
 include/linux/fscrypt.h     |  38 ++++++++++
 4 files changed, 277 insertions(+), 13 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945..63a5e0ad957c 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -144,6 +144,95 @@ int fscrypt_crypt_data_unit(const struct fscrypt_inode_info *ci,
 	return err;
 }
 
+static const struct fscrypt_prepared_key *
+fscrypt_fs_layer_key(const struct fscrypt_inode_info *ci)
+{
+#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
+	if (!fscrypt_fs_layer_key_prepared(ci))
+		return NULL;
+	return &ci->ci_fs_layer_key;
+#else
+	return NULL;
+#endif
+}
+
+static int fscrypt_crypt_fs_layer_page_prepare(const struct inode *inode,
+				    const struct fscrypt_inode_info **ci_ret,
+				    const struct fscrypt_prepared_key **prep_key_ret)
+{
+	struct fscrypt_inode_info *ci = fscrypt_get_inode_info(inode);
+	const struct fscrypt_prepared_key *prep_key;
+	int err;
+
+	if (!ci)
+		return -ENOKEY;
+
+	err = fscrypt_prepare_fs_layer_key(ci);
+	if (err)
+		return err;
+	prep_key = fscrypt_fs_layer_key(ci);
+	if (!prep_key || !prep_key->tfm)
+		return -ENOKEY;
+
+	*ci_ret = ci;
+	*prep_key_ret = prep_key;
+	return 0;
+}
+
+static int
+fscrypt_crypt_page_inplace_with_key(const struct fscrypt_inode_info *ci,
+				    const struct fscrypt_prepared_key *prep_key,
+				    struct page *page, unsigned int len,
+				    unsigned int offs, u64 dun, bool encrypt)
+{
+	struct crypto_sync_skcipher *tfm = prep_key->tfm;
+
+	SYNC_SKCIPHER_REQUEST_ON_STACK(req, tfm);
+	union fscrypt_iv iv;
+	struct scatterlist sg;
+	int err;
+
+	if (WARN_ON_ONCE(len <= 0))
+		return -EINVAL;
+	if (WARN_ON_ONCE(len % FSCRYPT_CONTENTS_ALIGNMENT != 0))
+		return -EINVAL;
+
+	fscrypt_generate_iv(&iv, dun, ci);
+
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				       CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, page, len, offs);
+	skcipher_request_set_crypt(req, &sg, &sg, len, &iv);
+	if (encrypt)
+		err = crypto_skcipher_encrypt(req);
+	else
+		err = crypto_skcipher_decrypt(req);
+	if (err)
+		fscrypt_err(ci->ci_inode,
+			    "%scryption failed for data unit %llu: %d",
+			    (encrypt ? "En" : "De"), dun, err);
+	return err;
+}
+
+int fscrypt_crypt_fs_layer_page_inplace(const struct inode *inode,
+					struct page *page, unsigned int len,
+					unsigned int offs, u64 dun,
+					bool encrypt)
+{
+	const struct fscrypt_inode_info *ci;
+	const struct fscrypt_prepared_key *prep_key;
+	int err;
+
+	err = fscrypt_crypt_fs_layer_page_prepare(inode, &ci, &prep_key);
+	if (err)
+		return err;
+
+	return fscrypt_crypt_page_inplace_with_key(ci, prep_key, page, len, offs,
+					       dun, encrypt);
+}
+EXPORT_SYMBOL_GPL(fscrypt_crypt_fs_layer_page_inplace);
+
 /**
  * fscrypt_encrypt_pagecache_blocks() - Encrypt data from a pagecache folio
  * @folio: the locked pagecache folio containing the data to encrypt
diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 8d3c278a7591..760e781f3921 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -266,6 +266,13 @@ struct fscrypt_inode_info {
 	 * the traditional filesystem-layer encryption.
 	 */
 	u8 ci_inlinecrypt : 1;
+
+	/*
+	 * Optional filesystem-layer software key for data regions that cannot
+	 * be handled by blk-crypto.
+	 */
+	struct fscrypt_prepared_key ci_fs_layer_key;
+	u8 ci_owns_fs_layer_key : 1;
 #endif
 
 	/* True if ci_dirhash_key is initialized */
@@ -323,6 +330,18 @@ struct fscrypt_inode_info {
 	u8 ci_nonce[FSCRYPT_FILE_NONCE_SIZE];
 };
 
+#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
+static inline bool
+fscrypt_fs_layer_key_prepared(const struct fscrypt_inode_info *ci)
+{
+	/*
+	 * Pairs with the smp_store_release() in
+	 * fscrypt_prepare_software_key().
+	 */
+	return smp_load_acquire(&ci->ci_fs_layer_key.tfm);
+}
+#endif
+
 typedef enum {
 	FS_DECRYPT = 0,
 	FS_ENCRYPT,
@@ -722,6 +741,7 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
 
 int fscrypt_set_per_file_enc_key(struct fscrypt_inode_info *ci,
 				 const u8 *raw_key);
+int fscrypt_prepare_fs_layer_key(struct fscrypt_inode_info *ci);
 
 void fscrypt_derive_dirhash_key(struct fscrypt_inode_info *ci,
 				const struct fscrypt_master_key *mk);
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index ce327bfdada4..3a68175aa664 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -144,6 +144,130 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
 	return ERR_PTR(err);
 }
 
+static int fscrypt_prepare_software_key(struct fscrypt_prepared_key *prep_key,
+					const u8 *raw_key,
+					const struct fscrypt_inode_info *ci)
+{
+	struct crypto_sync_skcipher *tfm;
+
+	tfm = fscrypt_allocate_skcipher(ci->ci_mode, raw_key, ci->ci_inode);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+	/*
+	 * Pairs with fscrypt_is_key_prepared() and
+	 * fscrypt_fs_layer_key_prepared().
+	 */
+	smp_store_release(&prep_key->tfm, tfm);
+	return 0;
+}
+
+#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
+static int
+fscrypt_derive_v2_fs_layer_key(const struct fscrypt_inode_info *ci,
+			       const struct fscrypt_master_key *mk,
+			       u8 *raw_key)
+{
+	const struct super_block *sb = ci->ci_inode->i_sb;
+	const u8 mode_num = ci->ci_mode - fscrypt_modes;
+	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
+	u8 hkdf_context;
+	unsigned int hkdf_infolen = 0;
+	bool include_fs_uuid = false;
+
+	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
+		hkdf_context = HKDF_CONTEXT_DIRECT_KEY;
+	} else if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
+		hkdf_context = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
+		include_fs_uuid = true;
+	} else if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32) {
+		hkdf_context = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
+		include_fs_uuid = true;
+	} else {
+		fscrypt_hkdf_expand(&mk->mk_secret.hkdf,
+				    HKDF_CONTEXT_PER_FILE_ENC_KEY,
+				    ci->ci_nonce, FSCRYPT_FILE_NONCE_SIZE,
+				    raw_key, ci->ci_mode->keysize);
+		return 0;
+	}
+
+	/* Keep this per-mode KDF in sync with setup_per_mode_enc_key(). */
+	BUILD_BUG_ON(sizeof(mode_num) != 1);
+	BUILD_BUG_ON(sizeof(sb->s_uuid) != 16);
+	BUILD_BUG_ON(sizeof(hkdf_info) != 17);
+	hkdf_info[hkdf_infolen++] = mode_num;
+	if (include_fs_uuid) {
+		memcpy(&hkdf_info[hkdf_infolen], &sb->s_uuid,
+		       sizeof(sb->s_uuid));
+		hkdf_infolen += sizeof(sb->s_uuid);
+	}
+	fscrypt_hkdf_expand(&mk->mk_secret.hkdf, hkdf_context, hkdf_info,
+			    hkdf_infolen, raw_key, ci->ci_mode->keysize);
+	return 0;
+}
+
+static int
+fscrypt_derive_fs_layer_key(const struct fscrypt_inode_info *ci,
+			    const struct fscrypt_master_key *mk,
+			    u8 *raw_key)
+{
+	switch (ci->ci_policy.version) {
+	case FSCRYPT_POLICY_V1:
+		return -EOPNOTSUPP;
+	case FSCRYPT_POLICY_V2:
+		return fscrypt_derive_v2_fs_layer_key(ci, mk, raw_key);
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+}
+
+int fscrypt_prepare_fs_layer_key(struct fscrypt_inode_info *ci)
+{
+	struct fscrypt_master_key *mk = ci->ci_master_key;
+	u8 raw_key[FSCRYPT_MAX_RAW_KEY_SIZE];
+	int err = 0;
+
+	if (!fscrypt_using_inline_encryption(ci))
+		return -EOPNOTSUPP;
+	if (fscrypt_fs_layer_key_prepared(ci))
+		return 0;
+	if (!mk)
+		return -EOPNOTSUPP;
+
+	down_read(&mk->mk_sem);
+	if (!mk->mk_present) {
+		err = -ENOKEY;
+		goto out_unlock_key;
+	}
+	if (mk->mk_secret.is_hw_wrapped) {
+		err = -EOPNOTSUPP;
+		goto out_unlock_key;
+	}
+
+	mutex_lock(&fscrypt_mode_key_setup_mutex);
+	/* Another thread may have prepared the fs-layer key while we waited. */
+	if (fscrypt_fs_layer_key_prepared(ci))
+		goto out_unlock_mutex;
+	err = fscrypt_derive_fs_layer_key(ci, mk, raw_key);
+	if (!err) {
+		ci->ci_owns_fs_layer_key = true;
+		err = fscrypt_prepare_software_key(&ci->ci_fs_layer_key,
+						   raw_key, ci);
+	}
+	memzero_explicit(raw_key, ci->ci_mode->keysize);
+out_unlock_mutex:
+	mutex_unlock(&fscrypt_mode_key_setup_mutex);
+out_unlock_key:
+	up_read(&mk->mk_sem);
+	return err;
+}
+#else
+int fscrypt_prepare_fs_layer_key(struct fscrypt_inode_info *ci)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 /*
  * Prepare the crypto transform object or blk-crypto key in @prep_key, given the
  * raw key, encryption mode (@ci->ci_mode), flag indicating which encryption
@@ -153,24 +277,12 @@ fscrypt_allocate_skcipher(struct fscrypt_mode *mode, const u8 *raw_key,
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
@@ -558,6 +670,11 @@ static void put_crypt_info(struct fscrypt_inode_info *ci)
 	else if (ci->ci_owns_key)
 		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
 					     &ci->ci_enc_key);
+#ifdef CONFIG_FS_ENCRYPTION_INLINE_CRYPT
+	if (ci->ci_owns_fs_layer_key)
+		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
+					     &ci->ci_fs_layer_key);
+#endif
 
 	mk = ci->ci_master_key;
 	if (mk) {
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 54712ec61ffb..ede451614461 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -344,8 +344,38 @@ static inline void fscrypt_prepare_dentry(struct dentry *dentry,
 /* crypto.c */
 void fscrypt_enqueue_decrypt_work(struct work_struct *);
 
+/**
+ * fscrypt_crypt_fs_layer_page_inplace() - encrypt or decrypt one page region
+ *                                         in place
+ * @inode: encrypted inode whose contents encryption policy is used
+ * @page: page containing the region to encrypt or decrypt
+ * @len: length of the region in bytes
+ * @offs: byte offset of the region within @page
+ * @dun: data unit number to use as the IV/index
+ * @encrypt: true to encrypt, false to decrypt
+ *
+ * Encrypt or decrypt @len bytes in @page at @offs using @inode's contents
+ * encryption semantics, but always using filesystem-layer software crypto.
+ * If @inode's normal contents path uses blk-crypto, this may require fscrypt
+ * to derive and prepare an additional filesystem-layer software key.
+ *
+ * This is intended for filesystem-managed data regions that are not submitted
+ * through a bio and therefore cannot be encrypted or decrypted by blk-crypto.
+ * The caller must ensure that @offs and @len stay within @page and satisfy the
+ * block-size requirements of @inode's encryption mode.
+ *
+ * Return: 0 on success, -EINVAL for invalid arguments, -ENOKEY if the inode's
+ * key is unavailable, -EOPNOTSUPP if filesystem-layer software crypto is
+ * unsupported for this inode/key, or another negative error from the crypto
+ * API.
+ */
+int fscrypt_crypt_fs_layer_page_inplace(const struct inode *inode,
+					struct page *page, unsigned int len,
+					unsigned int offs, u64 dun,
+					bool encrypt);
 struct page *fscrypt_encrypt_pagecache_blocks(struct folio *folio,
 		size_t len, size_t offs, gfp_t gfp_flags);
+
 int fscrypt_encrypt_block_inplace(const struct inode *inode, struct page *page,
 				  unsigned int len, unsigned int offs,
 				  u64 lblk_num);
@@ -541,6 +571,14 @@ static inline int fscrypt_decrypt_block_inplace(const struct inode *inode,
 	return -EOPNOTSUPP;
 }
 
+static inline int
+fscrypt_crypt_fs_layer_page_inplace(const struct inode *inode,
+				    struct page *page, unsigned int len,
+				    unsigned int offs, u64 dun, bool encrypt)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline bool fscrypt_is_bounce_page(struct page *page)
 {
 	return false;
-- 
2.34.1


