Return-Path: <linux-fscrypt+bounces-1632-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id h0YyG37fHmq7XAAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1632-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 15:49:50 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 095C662EA86
	for <lists+linux-fscrypt@lfdr.de>; Tue, 02 Jun 2026 15:49:50 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=JY7ugjD+;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1632-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1632-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=reject ("cv is fail on i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CFC2A3033F56
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jun 2026 13:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BCF3939BF;
	Tue,  2 Jun 2026 13:41:29 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazon11013042.outbound.protection.outlook.com [52.101.127.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B8821B191;
	Tue,  2 Jun 2026 13:41:27 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780407689; cv=fail; b=Y4Vs5FpZjMdTnU5EVUWzX8yOTKslgbY4VrKYcoVSPuDQFhKVBLY5cTUrG5OAzluVikGjT+gg1zbYvkE2FURUOwfeu2fItzyED+keZYJAQbzgtbDDscyAgDLyo40dNBW/ozw540LvPpYRZvVvpWl3uI8Zzmy1K+izDkiXZW5fH5I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780407689; c=relaxed/simple;
	bh=Qt5A2biJUbq4HI/SNgd+vnZJl3dlzphIZc46zKPsh9k=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=ZAEEXDLIB6twr6Pv4xBvDQ5iVQ19/C5yQPDtftQaIx6Dh/0iakrY09d4yj/GTPe7UdcwUhpJtm62TbqNrz1qa4MrrXYxsQyHjcSt9k8XbmHNlz69M7SU/cCLGH+plZv2JSCyzI5sbi8ELT+C78J569rdAmSQo5JsxBF9eD5OYHM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=JY7ugjD+; arc=fail smtp.client-ip=52.101.127.42
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SSM7lk6YmIR+lCyaXtU7o9JaWz4aLusIgU/I1Na2OPxxVoqRv3Sz2oBPtzJTI685vdwBxQHTGfgSHCRv06Fw9s2dcDVGIYrMJCUxticCQR3st9xXKy79Hta78Ri8t4yFnkZ7DwpwmvGI1BxQxBebeUqZuqwegJt3VKlcWBCoiJKoeOj0uD3YBT0FSVyvgH1lwS60PCTUenojLqteYrxmlfp8hNNOWmY5rI6vdixkwWgD39zW5x99WUvN35sUjo3yi/yvT+MK+tnP2usUT3wsK403Ji1GrIrilBiWjs5N0DXJdpe1kFXiicPbi5sdjUeBZJqurtOcljEJXWpe/9mx3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPmEK/xlD+KQ6Dvy37bvrzvJZGMkGmUwRSonPMt4wIU=;
 b=geHN2JuqEtJCIm613lzWuQ/Pl5PjqsB5BlV6SwSVOXo7qqLQUMiCLxy+UIScV0mDYMsK6T/pJPxqxyWgE0Dicj2k6dQjyavYMNRTZ1ko4mJKAMR0l6FeJJELef3axch7Pyy8jkE2VGQeCJaIloPsaFt07GauOXMvAaxclcO67gMOnTt1Tac3cOHMnQdmCffaeHx5rCphxBoBqIg4KAPKiFNLm3l8FDX/0GoSdGI/vJNccrE8WXHKMtCzPumvLRtxvkpcaTDgghNxZ284Yaeo2W1ex9wtcwTBhGI1dKIQJb2niys3IbAlrXbLFo045Jw5QKt5D7+UmLeUTU8wJ1DAtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPmEK/xlD+KQ6Dvy37bvrzvJZGMkGmUwRSonPMt4wIU=;
 b=JY7ugjD+oYG9iPjOrUyMisuK/hWPpQyN47Rs2qsf/UZe6DOLlOA/bme3en8oPAWDDRhywgM3iZ7clMV8YvmSX/1ChAjBg5o2OR6UWXvxj90VuqQew+JIwKoBMtVOqcnIftiOjETdzhWWuT3EEcPpc7aYjyhwvUrHQAzdSIf1w0+xqV0SpDbptTgHb1eSaIa9InV6ru1ewHdn0yFdoU1aKcvJJn/5ar/Nk7L+bAieWdDFR8I9oF6BgsBSFBcuCEL21odll5B+VO9RWpFg05FS9eq/9VJyRhtSOv4N1cwgkyQXABqFGdTLHqPLEGfGlJfvdMk2DunDdWb5gWpFyEmH6g==
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by TYZPR06MB5950.apcprd06.prod.outlook.com (2603:1096:400:333::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.12; Tue, 2 Jun 2026
 13:41:20 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0071.015; Tue, 2 Jun 2026
 13:41:20 +0000
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
Subject: [PATCH v2 0/3] f2fs: support encrypted inline data
Date: Tue,  2 Jun 2026 21:40:59 +0800
Message-Id: <20260602134104.348655-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 0e0cb6df-bdca-46a1-92eb-08dec0aca143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|7416014|1800799024|366016|56012099006|11063799006|18002099003|38350700014|921020;
X-Microsoft-Antispam-Message-Info:
	k+/MAsXsO1b07jJ4xDnwbK2H1xI0AVnTAQeO4GDcH/pifYRb+zgep0ism/lNtgqudaG7l7xIT3h+eNxTGbV0pD/nMExz4zYMhzceYgP+6NaIEp77ZEeNZ0HD+Jj6PCh4DGtFt6tGlnRLrn1FovgYsDC1JYwgKwCcDYyPxWTgePEFe8S9GtUciIU0JIdnZ+/GzwLrwuJC71TrTiCuqEc1NJ73xPmEeqtJdln6D15cW2FxTVwVEwW9m/SE8HkZKMTm+C8fVmU/IM3Gg6X1wUCSPoPrPeUi5U9AhPZqKKj6sOnFOcqfaHKEQ8GTxs96FSV3byLZEsWNFmOTxxDCpOfCHDv0wOinubzpKUcxSt2wuSPUqNPheCd+cKiJd3jsNxckCEo6To92zjT14DmEgrgJbpDzsZ60Bu9g1+NgDvVEbc85yxY3nGJTfsHvUmFvX8doQiUJ1RkuH3PVTsZ8xPnJvMkdOwWszamZKdYQOa/xX6FGdiT9uEAG6WFlHLZmAgdmanX/wrbMImjdJRs8bpH6KEh79ErvHIhwi7XNMAB47GTBdC3utVM7xukR2zmRV+L/FeKfwZFcgLbv/Rxk3KeY5P7AIdDelcxZHsHdCXy3IqEWIhukbqKoCKncggq0WxVJFCzCK1umNomoiWviEecJSvoGphJIg5b6eQkwSm34zW9RzWOEoc5jqJhS/GYw+g6VMPVPtxfbkfRCxrJBxnMYZwStHMnHKtI5yu+Oi0eLU/Wv7xQC0mBAErBs6Xe08kh92DT5RmR5KGCk+JtF9tcO+A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(7416014)(1800799024)(366016)(56012099006)(11063799006)(18002099003)(38350700014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+yIvIdE72X0kQEZXAQN4jxaEQ9la5H16YdNd42NCGEJULDIBvuwcL2O1V+17?=
 =?us-ascii?Q?VulH1gN0az3LP82IVt/CwArVQ9rUygZJjd4DOfQwHkZQW6v2pEAWl8vr2snz?=
 =?us-ascii?Q?IMN1djfK8CBJcTbfXz9PiNKMSLvKkr23JbZsk5vupw11QAImIw/36fBhyZDx?=
 =?us-ascii?Q?lIf6HIseCGXAinV4FVUEM85CC8ABi9vZ52Nq8VS6f403myD8U6Yi8mBmzjkd?=
 =?us-ascii?Q?EEGQluK2ey5eDXfoKF24VDfU+k+rIEr2AuhenQSOlmCEmVZboYQr0af0QlXA?=
 =?us-ascii?Q?Flt1R5uvZ5quVvPrbF6Nih49WS4nth8rBFDUX8/v/FMGsYQB0ywlIAYlz2Bx?=
 =?us-ascii?Q?C2P9QHzoKIcnDlabKMQW2tazaWlJEKtR9s76z8vpNNE1tZ++YkNmghiBgRTC?=
 =?us-ascii?Q?urx+Hfbojetm42gUBWB8tofpG7PGtcp1U5J3I/WmRZ7gXN3P5Dzj0WLPujAe?=
 =?us-ascii?Q?LYoUlsQhV1cFJJxk7Xt4Fjv9g7vsJL1Atn+KofiEhGEiR6eZOKPKqqEejhoB?=
 =?us-ascii?Q?s+0ongpfPjRftVvnLuYUrEpeue2GzAd9qXpCK4lGsuqatVdcnSxARo64VdKx?=
 =?us-ascii?Q?wZct3haY7Dq5DaPD8izf1jkDv7Vx6z9kOj5SOwrsnVuvM45s/42K2ulE5Omc?=
 =?us-ascii?Q?PFexu5RJytOXOfN2/cab653ZIFmkmKSZ2n03nS1oKNRWKNieR3bEC/2lFXVD?=
 =?us-ascii?Q?Ovt6QnP6gpraIQlZhBIA3OM/APbbW3mt6uuxaLaMeRualIGH7wnbAF/yEezh?=
 =?us-ascii?Q?4Y2Ws70Qtfu0xCpae6Dq14kvtGYOpfbJbeQH64V0gHEJX/jrlYf7RDMH7UF2?=
 =?us-ascii?Q?X/UqQH6iXmAuv80sOvbPlI4nHGOoogKQ5NNi9dB+S787tcJIxhAVsYXodDZ1?=
 =?us-ascii?Q?5MRNTb1uxhFosZn2Pc3fSvaL9IFhSCDjuKE+MmBMRht2tNcsLTEKY9CZqiK2?=
 =?us-ascii?Q?YJyKj/cVeEBdAmG188qEcZck5XpBQL1o0uOhQtnkZLBaVxxUhXiBUn5TaP6s?=
 =?us-ascii?Q?AML3yzQ5kN78XsPnhEJ7J0FIvpA2rERugeWOP5AyVCcvyKr5QjY3J4yIOjNQ?=
 =?us-ascii?Q?AaGeecUusjUYiuo1HeQD/aXLw8cD5q/Cerdl4MXddaA4o7HUWT3oN4JKQ8Wh?=
 =?us-ascii?Q?U/mPSd6O1be0nwjVW0SI3+u6eTNi9bWcrafoKgxFLUPFCdiK0xX2GtYWqag1?=
 =?us-ascii?Q?inq90Qd4Kvc72g343FEsnPvQvaoQKMbJ02Tx0++n+myL/ifzLYRpJMurS1ui?=
 =?us-ascii?Q?wytLpqq1FjF6MgSAkBHp3c18oX/LFlr56bydy5fcRChneGg26Y24KOqgQInr?=
 =?us-ascii?Q?fmsQdHg1BZOKga6LTAFYfLBYuSd/Dh5MnMv3RXGaxwtbhQJ9WobgsI5OdL6m?=
 =?us-ascii?Q?jidOkR2PokcPrVNoh0i6LJyi/Phv5hq9SfuPAoqYZDeumObu/AwKeW5qADHN?=
 =?us-ascii?Q?IeCWzY/6fERN3SDsDupuI1LVNA3sIHgUzjIMbpt26M+cumVa5vNfjxWHJ1UM?=
 =?us-ascii?Q?pZY/VleYdlvqRqqX37Vb7VHqaO8j650V1qTajdzepnggmKPCsnd0sfqHaFHG?=
 =?us-ascii?Q?P/F/7AUkxUOGfGsYLi+RoQcEtIOjdCvAkFYNSFm8Y5IyMCdsH3RbIkCtmt/X?=
 =?us-ascii?Q?y+IR4z9Y60kUTWtOtZBNqZk7Etf436gztm92l3yIkGHpBjEMNkz2ZwesS2IY?=
 =?us-ascii?Q?rjNkk7BkcU6lCy80zO9G9QBiND2LM8ij49tZtiZktjv/avNNLnRBwIg68v0p?=
 =?us-ascii?Q?3dWzFPGRsw=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e0cb6df-bdca-46a1-92eb-08dec0aca143
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 13:41:20.6947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LhEeIyaySI7bSobraCiFinH6Ac4uig+UoQnQo81rawiL3VZUeRT6ORjAF870WA2Fs2FFOdQH8GgZytWQSKL5rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR06MB5950
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1632-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:jaegeuk@kernel.org,m:chao@kernel.org,m:corbet@lwn.net,m:skhan@linuxfoundation.org,m:ebiggers@kernel.org,m:tytso@mit.edu,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-kernel@vger.kernel.org,m:linux-doc@vger.kernel.org,m:linux-fscrypt@vger.kernel.org,m:liaoyuanhong@vivo.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,vivo.com:mid,vivo.com:from_mime,vivo.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 095C662EA86

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
read or written.  Raw-key inlinecrypt support is limited to per-mode
policies (DIRECT_KEY, IV_INO_LBLK_64, and IV_INO_LBLK_32).  Per-file
inlinecrypt keys are not supported for encrypted inline data, to avoid
per-file software tfm memory growth.  Hardware-wrapped keys are not
supported for encrypted inline data.

I tested this on an Android F2FS /data device with inlinecrypt.  The
workload created 10000 encrypted files under the same fscrypt policy.

  Size  encrypted inline_data  Inline sample  fs_used_delta_kb  Avg B/file
  1K    enabled                200/200        46344             4745.63
  4K    enabled                0/200          85280             8732.67
  1K    disabled               0/200          88808             9093.94
  4K    disabled               0/200          80728             8266.55

For the 1K workload, encrypted inline data saved 42464 KiB for 10000 files,
about 4348 bytes per file, or a 47.8% reduction in filesystem used space.
A raw inode check of a sampled file confirmed that the inline region did
not contain plaintext.  The 4K control workload did not retain inline data,
as expected.

This is Android-focused, but the use case is meaningful in practice.  Real
phones can have more than 200000 encrypted files smaller than 4K under
/data.  Avoiding one 4K data block for a large fraction of those files can
save several hundred MiB, and in some cases close to 1GiB.

If keeping this limited to raw-key inlinecrypt is not the right tradeoff,
I'd appreciate suggestions on how encrypted inline data could be supported
with hardware-wrapped keys.

Changes in v2:
- Split fscrypt capability checking from software transform preparation.
- Limit raw-key inlinecrypt support to per-mode policies; per-file
  inlinecrypt keys and hardware-wrapped keys are unsupported.
- Use one data-unit helper and process inline payloads by fscrypt data-unit
  size.
- Update F2FS inline-data paths and documentation.

LiaoYuanhong-vivo (3):
  fscrypt: prepare software keys for filesystem-managed data units
  f2fs: support encrypted inline data
  Documentation: f2fs: document encrypted inline data

 Documentation/ABI/testing/sysfs-fs-f2fs |   5 +-
 Documentation/filesystems/f2fs.rst      |  34 +++++
 fs/crypto/crypto.c                      |  43 ++++++
 fs/crypto/fscrypt_private.h             |   3 +-
 fs/crypto/keysetup.c                    | 167 ++++++++++++++++++++++++
 fs/f2fs/Kconfig                         |  14 ++
 fs/f2fs/data.c                          |   8 +-
 fs/f2fs/f2fs.h                          |  37 +++++-
 fs/f2fs/file.c                          |  24 +++-
 fs/f2fs/inline.c                        | 131 +++++++++++++++++--
 fs/f2fs/super.c                         |  12 ++
 fs/f2fs/sysfs.c                         |   8 ++
 include/linux/fscrypt.h                 |  24 ++++
 13 files changed, 487 insertions(+), 23 deletions(-)

-- 
2.34.1

