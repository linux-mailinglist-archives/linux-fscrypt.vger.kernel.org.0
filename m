Return-Path: <linux-fscrypt+bounces-1633-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ifo8EoXfHmrRXAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1633-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 15:49:57 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AEBF62EAA8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 15:49:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=I7ypdBjz;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1633-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1633-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 229C23032A80
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 13:41:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 698693E2AA1;
	Tue,  2 Jun 2026 13:41:31 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013042.outbound.protection.outlook.com [52.101.127.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FFCE3DA5B1;
	Tue,  2 Jun 2026 13:41:29 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780407691; cv=fail; b=t1BEO8FBn8yyr2pk+qhhCRTliTDfv6cePDP628P9Nq2ESc0JAwQrDot1BQnHug5J5f1ZH5sui4TIiroeZ6tVUEj9uFMm/9HSh0elXeNPqu1zRJEb39HtJLXXsUJn/jvTs1uBexWj8enWY1N16hGO9WKtbpTihHBQsZ/KOQgnh94=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780407691; c=relaxed/simple;
	bh=jdPpZb+7h10VhkVm1aWlCsm64ZSSStaSTwV51KFxWBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GMJEpIjw5FIlabtppP3PtcTPUuXkMBOWNN/3sV/Cp625RZJFa3oq+MAz4dIFRyFpo/ysd6Jqjl8gqJOWe9hN/SvwXvP/4RmrE1p7RAnQIMZ7djFWKlb49TdBysj+nj+shzq3Z1l/6ERbtmNrTEIY3ZGILbZ2e6wa478G/m3bKBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=I7ypdBjz; arc=fail smtp.client-ip=52.101.127.42
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gGRHD0kTXx0HdCDvVnkHFq2SNqZMa46T71T9QeRjWSVv96B+DuMRtiuohzILGnRsR+bmckmQPKLXD7K0xzkDoZKOFUlLMDRz9vXpVMrSYWD9oqVFcmovvuC+D5Q0lYdGpglzPlSjZZFEbl2f6B4vzwJOmt9Wf9NhshUYQYiqZAu+ocpPXjENwKYFtzA7vmD2QaKsgptOCaFA08hvNvfZj2Od6YD+yikPBXUGBBj5RMcwddyMr0EapArrivfajSGdXqNw3kP1C3kzO5N1I1Q/dcg5XH9j8Bx6Cxh+yZyrFwKY/GUlZx7eEU8nslrrY1tbP19D9yEwEyYThSiuHCUiJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MZs3bw6xDa+qwRBplqh+zN1aFXtmsIvM3abxmh/s+4s=;
 b=csQ8FLqbRIEj0t/l2+SyY3nCfRY0EyWqYSBvj3aim04F54JjCcoWdrSJPwnRbRxNdmPZR93lgbL4dhAf2RB+h0IYUYSdnPxzXm4FQXIco8QHeHfXP/B6Q4cGOmLwFn5n6ahsIHYokBeveFtiN3XKyr7+Cs36ide1TrQil7AOnKuZF50W1BAVJW1m9S5caZmkKOipVnA8MAdEJnWDoZEHv6V17DHWYXaWDt1OJLgVYlOIj37oMbPTJgOS1s8p6WfuBwXMhIiCRSy3nV5tOT32qkPJl7iLd7dinoX+OurG8jbe0L4McEZFBj+c5McjuBqbcUZv5UzNvCbDPRD1t1m1gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MZs3bw6xDa+qwRBplqh+zN1aFXtmsIvM3abxmh/s+4s=;
 b=I7ypdBjzReFEP860ZjHTpWJVK1kicGalOGHjHsnwiJQXD7DBQZ4/SiMzO1Ensp/zvdr3thgsDWpTtiEFgUZOWXZzvv83SQvcr/wHEccp3WrPGVBxYCn+rr5yra8hKu/3S1UztaWvyYrcyXWA2NWD/ExW53Wyet4wQplb+XKpkBCYadZ44IzfGgoYVfhPWWXJQk2bEGhWNWV+86r/Z3pxx8tqNJ0pesTXMjGjCzjxeRcyafrCAikYoMgYpT+tvB39D/9WsVmq5cNXPFSvFbT5MdwIJDqxmRili28nfyaebb1CsCuZUiiSHd/Mz6TScDk8xqJgG+erv9iKRLJR5wjXWA==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TYZPR06MB5950.apcprd06.prod.outlook.com (2603:1096:400:333::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 2 Jun 2026
 13:41:25 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 13:41:23 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-fscrypt@vger.kernel.org (open list:FSCRYPT: FILE SYSTEM LEVEL ENCRYPTION SUPPORT),
	linux-kernel@vger.kernel.org (open list)
Cc: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
Subject: [PATCH v2 1/3] fscrypt: prepare software keys for filesystem-managed data units
Date: Tue,  2 Jun 2026 21:41:00 +0800
Message-Id: <20260602134104.348655-2-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260602134104.348655-1-liaoyuanhong@vivo.com>
References: <20260602134104.348655-1-liaoyuanhong@vivo.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0038.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::11) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|TYZPR06MB5950:EE_
X-MS-Office365-Filtering-Correlation-Id: 11897c65-e0b3-4fe7-6cc9-08dec0aca2fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|1800799024|366016|56012099006|11063799006|18002099003|22082099003|38350700014;
X-Microsoft-Antispam-Message-Info:
	pNKxCjX/b595JjFwIw8PAjkmVu5YikJxGslJWe4Pnw/xgxP1NR83D1icpb7cTtbuji8c+vlGXP++zPetzohV3hBdgSuT/v0UVOjWs5faAWrs1RzQuNuKf8Tlwq66MxRg8ToeoxkXOjP79ggAqy9voe+C1fWfKGatqPkxpc+DBBRNuiSu7IXRke25/MkMFSaIStNpSao4Kr7GJY9luR1MAY+suKie98UADJhNgE7BAPJIvypYuzpkm0SMKgyXyBb7JpfmSAwWlpk+lYLwPoeaNRYXG5VXZ/x3AFcCqdmFCGCwdf0rZb/pRQC9SPAc/eaCdI9DEDmGTJsrilZXb2VNlLGTHYqs9f1ExgrXa46obc6NDCZywGD6fWynsVvGW3aSLNrCVI6QrIllrcV4raDuX+c+6u6fxirR3NCLXnT1tOcidHHFfOfopWy8rrhejjRc784/xGzkByZyYhtdnyQna6V/qBwf28FlfoN3GL9u6MTdlaBqChXV+Sf/I50yYWA6SU4kRxVUwSjejGxwWfOvbx2R3xP/Nk9hCzCUpPcg5Naa5BDQ7FnYGF/MaeTKEhQLPBvrgJgXkMKYmoZVwLKJc2ohXESj6YGlfDf4QxpxHHAARDloxHQsjTK9LAZ0XhWzbAx7wxtCZb191IwKeZFs/uldykauKDiaVQQuY0EYJ/rD0nUi+QHJOqBscoj1FUEvn9zbmJeYjlBxdrJKXlFGYuNMGnh0MxkfRqcl+RASgO7RYxJfPX1WeowYMwocqciV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(1800799024)(366016)(56012099006)(11063799006)(18002099003)(22082099003)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xR8J8TaUgR/s8U01cboxCgtIoBhyeev+BNdn2FpmjMs/Y1aL5k07wsUGnXLJ?=
 =?us-ascii?Q?JNsbhGt//xEF1bScuH1HG+XTePdZ1dSI3jflHy9noEP0EMw5K4SqaEzXfS1M?=
 =?us-ascii?Q?N6sfvL6ZyOQUhTddPLr6HS0nIeId3uDgoMZLHHE4KWfLKIH7tAg0Qw4XJUmp?=
 =?us-ascii?Q?aArKuF7DdNhjCCMtdy/LlN089Xpxz4ZZeepV12r9ZYMyWynDpMp6RRHoBcPG?=
 =?us-ascii?Q?J9R/dM5EY1HRuz+neC74lj/MyvZwGHGbak2ge1hgPA/62r4cGsn71Es9mLZC?=
 =?us-ascii?Q?JgBwTA4ccZHdLC/UiiJVrExMY5S3QepGGDy0hyZAvkyngJ4Qo+n3ZYY1zvvy?=
 =?us-ascii?Q?SXgfH54IGUxUgLNxpbQSj6i9/ATKxUteJfDUvT9A7tNXOBRGiNs/YZUR57id?=
 =?us-ascii?Q?R1wHt8b/SNHNILanedVwmIYVQ/lZQGiXJvd1H3GPKjVjRGCV8/0rHIXMfZ3i?=
 =?us-ascii?Q?91GolQgtJHZLXjdFdS4Qf41SfjatUtp9GzdEXEQXxaNBPacwr+kFF9WVRarP?=
 =?us-ascii?Q?ynWUliIxO/K5Ph+RaamhCqaW3vVHUCaXEYiWdFEHy+DfTEvPRpT8bz4ME//P?=
 =?us-ascii?Q?Bemx1j6liWeWNJU7w2xwAFibRQ4Kk0g4IKqIk13HRScdKzEQSAlvVroKA/go?=
 =?us-ascii?Q?0xz5OiGl80/QfCdjDqNwA/Yf0OQq8pzMOPWMBXS7Lqb2xjtjZzKVHT9fo3UZ?=
 =?us-ascii?Q?/swTObHxLVSZUa2athObjVqB8vpDOQFyQMqyKKq8mYf2LxJjxptxmpeL2lYh?=
 =?us-ascii?Q?r1AgZ/RqoWqRTNejvlQdJn/ONwnEqcQruJ0Z+3ij445Jdl8rgo87gqbisJKX?=
 =?us-ascii?Q?GFxShmBnlFi7m4AJwhH14+Jm+FqMBMol96nzvPJRSJ1FaNaJZirjHW7dkj+o?=
 =?us-ascii?Q?UX5+eKqqrxWSEd0Oxmtiox7Bb12XIrsUf/M+DQOQRFG/O+qQs6HkCw/FBJJj?=
 =?us-ascii?Q?Ek6U/hn4aK39sMVJpzo+98HUJZo00yLJXx4YL2HlTtUfr62I3fCbE3UGh6Jt?=
 =?us-ascii?Q?XzOY0Gkmd8DGK2NrqDLPCd6FCT7JPBmSkc0ziOzwE8HSixda83kTMxyxeeIg?=
 =?us-ascii?Q?5YRgq0ue7HFECBAn6UryOLBR8M7Zi7/1HW7wU2GMYkVGrY0WI5ekXGuQuImS?=
 =?us-ascii?Q?FzbPQysqAWMgt9QFcGBzyQOIYQIKrt+C9XxBqpkuDtfORDml4BSKPDpmt3zS?=
 =?us-ascii?Q?mDUta0VfuqyC1HlkLZNZCxQnjOsAJNf0sc8+qx4Na/f6u0GjiM0krfeqnoLT?=
 =?us-ascii?Q?cu5ppmG19jjRsjNTEICuJ6qe3HEDnzDetROsULgKJGfPw3pB9N+CiyMtVwRc?=
 =?us-ascii?Q?NgvR1ARWjm7DPaV744/oQqDzgbUA5K5T3Pk52HLWL1MHiELQIiqbWN9gJ7rW?=
 =?us-ascii?Q?4qeO7Nusxs2QGRKgH6g/A9vqSva8bc1wFmcyBZjDlwHXRg1PMDs/uwHUhjYk?=
 =?us-ascii?Q?pWga4lDk5CVheZkxmqik4QpZhyWkniH+inYbVJktG194gDrGufKM7LfYTw3d?=
 =?us-ascii?Q?tiJog6DVldZti9pxFdoeTJqm533+yL14rbA5Z5mT2i7UkV9n9mpJinA8aDTu?=
 =?us-ascii?Q?YynEc9BGP6vR8BLqTeYrfnJLiY1yG/QbyBnQ1jlNjhU4wZHJQHaooMxKRivc?=
 =?us-ascii?Q?niOQGSHWv9Lvo2Owl+K07Cp2Ia9HVxBrZcfQy2bJEZN06MAkydboJr0jI9o2?=
 =?us-ascii?Q?LAvcG5UjlOnKC4D7MUinz6bLXoEHwdahsTzn91siaGn3i9FxLV2gABulohWp?=
 =?us-ascii?Q?hNxlWL3O9g=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11897c65-e0b3-4fe7-6cc9-08dec0aca2fe
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 13:41:23.6681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O1Nm8VPGa8AXViXHKZB7J6pdCLyrG3eaEro9Y0nbIX47t90FfFBhiyCekVTTXgweF4cIRdhuQhnP+MXqnGB2/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5950
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
	TAGGED_FROM(0.00)[bounces-1633-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vivo.com:mid,vivo.com:dkim,vivo.com:from_mime,vivo.com:email,vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1AEBF62EAA8

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

For raw-key inlinecrypt, support is limited to per-mode key policies
(DIRECT_KEY, IV_INO_LBLK_64, and IV_INO_LBLK_32), so the software transform
is shared per mode instead of being allocated per file.  Hardware-wrapped
keys and per-file inlinecrypt keys are not supported for this path.

Signed-off-by: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
---
Changes in v2:
- Split capability checking from software transform preparation.
- Limit raw-key inlinecrypt support to per-mode policies; reject per-file
  and hardware-wrapped keys.
- Use one direction-aware helper and process regions by fscrypt data-unit
  size.

 fs/crypto/crypto.c          |  47 ++++++++++
 fs/crypto/fscrypt_private.h |   3 +-
 fs/crypto/keysetup.c        | 178 ++++++++++++++++++++++++++++++++++++
 include/linux/fscrypt.h     |  24 ++++++
 4 files changed, 251 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 570a2231c945..a85ea313b0d9 100644
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
index ce327bfdada4..2cb629d4383c 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -400,6 +400,184 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_inode_info *ci,
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
+ * encryption for this inode.  Per-file inlinecrypt keys are intentionally
+ * unsupported to avoid per-file software tfm memory growth.  Hardware-wrapped
+ * keys are unsupported because the software contents key is not available.
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
+	if (!mk->mk_present || mk->mk_secret.is_hw_wrapped ||
+	    ci->ci_policy.version != FSCRYPT_POLICY_V2) {
+		supported = false;
+		goto out;
+	}
+
+	flags = ci->ci_policy.v2.flags;
+	supported = flags & (FSCRYPT_POLICY_FLAG_DIRECT_KEY |
+			     FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64 |
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
+ * already prepared.  If the inode uses blk-crypto with a raw per-mode key, this
+ * prepares the software form of that same per-mode contents key.
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
+	if (mk->mk_secret.is_hw_wrapped ||
+	    ci->ci_policy.version != FSCRYPT_POLICY_V2) {
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
+	if (flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
+		err = fscrypt_prepare_per_mode_data_unit_inplace_key(ci, mk,
+				mk->mk_direct_keys, HKDF_CONTEXT_DIRECT_KEY,
+				false);
+	} else if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
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

