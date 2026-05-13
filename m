Return-Path: <linux-fscrypt+bounces-1602-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKh6LFpNBGrNGgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1602-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 12:07:22 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3072D5311EC
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 12:07:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EB3823002B59
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C289538A711;
	Wed, 13 May 2026 10:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="EimOGjRC"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012063.outbound.protection.outlook.com [40.107.75.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350B43859E9;
	Wed, 13 May 2026 10:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.75.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778666692; cv=fail; b=gOrCQQvBLw8bfeiFpcnGiNWU2vWOe9i8yfSdIEAigo9vUlpB5iJnsMkvRTgkDwvJ/Jg5aCeSumQK/iq19xSiUJPg/U6qEknF1O9P+NusT9VwVSrljVA+Eqfqmrvc64v/nNUBc7WiyKfg9WxH/K+t03GST40ahPt9+sbTVWEUIso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778666692; c=relaxed/simple;
	bh=iXzTMucpuDL+JvBQI2EEhp1lMo/eZOj65ACPqg8VMuk=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=WQzu+Nd0f9Ip6/Zo9CTlW4PqMElMd3phkuj9bZQADbp9vX62lajL1D0PNLQ3WfAuqzG+umKovGldOreUOLVJItExSBWRuOiN6cwxFW//0uuIL9aK4FQgsCbHvr5iBK6TthLEZaSVwMMSD0Jel7hCbs3DSVOzRNxSFjjl9CQOmEs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=EimOGjRC; arc=fail smtp.client-ip=40.107.75.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=APF6lA0hjUtImtXJatFHAHPCgKygBvv4Xp7RB0A8sgoooQDfrqCJgKMqu469nqehAQWhXJPIuu45VYs7sz5hNBBZtJ5FRq8AT+pceZHS8TpVHmetKPwSg+f6OOrdS2uTJf+W15KPvqJV7GIr2dg8LDs1uZLzfIw1cJDpFLqeQ0OvfdnHeL6k4uFezlWdEiWLKhWojvgpKOLtp2bZSyUYZfJdWA65PI5wBe08bNHTf2I7uhpzCIxEvKj7sVVC+9P3Vs6z7Q5smSeZFil7wV17hI6HuWVPROegaposo5wrLKYVbRIgY7nGW3UvzEajvph8R5GxZZZy3apMLkt7xANZ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfgLXHdcpZsz3Mfp7svLEyc2zEQGQ9Lvjes6ICsyHC4=;
 b=FEM6ag+lgEAXfj+XN2QZgfndEgiPA3k4rLJ6OFUgSGSQ+rVyYDmy4BGvLuOWZwNl+AVVBLr4SHIDHh8uXxn8R93oodaKztHYjxoo5pRn8VwDdcMRvznoaCzzbhbg06FyLSrrqIJnt0ZXq/DXp5NmQPrD5rTPq3uaS4dRwjCoxk9Ss7lKVds0Mqj/gmUkIoKmX5pd5fVbpYgiAflaUVRs3OLEpi9p0vM537Lj9Gfm3H0zjNzAo+HhwcTQi+FbJbam/Uj07ujzum4VMouCvKyKMPHusTvf50Zxz0DEYfF/hoOlRj6sALDsR4PhfLj+KD9a9w5IsFM2dfrqUfuyVyIA0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfgLXHdcpZsz3Mfp7svLEyc2zEQGQ9Lvjes6ICsyHC4=;
 b=EimOGjRCTeaORQU8PYxAQie15oebA2uEIZlQ9hcZiIskp5Lg4eUllUuKNAio8tiVKG8B3AZR/FdHzsyKZr5Q3ASAJUczcSDQdkemjGSTYDxM2kXR6W9G3Ju7bVMah0TfrtKxDsjhGtF9L2HCzqe01+cwuDvJVExeQKgVoG3dm0A6FuyTwR0h9q3w5hqMmC9wpjQfvz940ClJOohH2xtDMNvT4PCS/VS4V8YnPcPR0HytHEl5UafXYNnjqkihv0acGP4AQ3nh9XBrP+3/I0iQ7jA7ha+mS5tgYhG6iv+Tf7gwqTtWVba9j/Krmy8U5k1qC3MGw6jqyLxRegjI5o2DMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by KL1PR06MB5884.apcprd06.prod.outlook.com (2603:1096:820:dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 10:04:43 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 10:04:43 +0000
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
Cc: Liao Yuanhong <liaoyuanhong@vivo.com>
Subject: [PATCH 0/3] f2fs: support encrypted inline data
Date: Wed, 13 May 2026 18:04:27 +0800
Message-Id: <20260513100431.299904-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-Office365-Filtering-Correlation-Id: 62f40f44-8edf-4f2d-36ed-08deb0d70e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|7416014|376014|18002099003|11063799003|56012099003|921020|38350700014;
X-Microsoft-Antispam-Message-Info:
	W+Sw+Gpnf/RZB1scd1qqKj6KbrpFNgKcc4k7agNEuTuIMRvg74hJwHe61gLCbPK8pnxQf2QF7jug65LJJy9od6/jAWCXSwqQlP8pEVp22cZhMfLsMDc+pdP7yYrEk9oqATrqCr4S0Oq7/e54L2qPFnc6GZmZ78HIon8I1sa8QkucCwiaWCCPexrPIczlAmfg4aRK2qt8EX0joX+uyof1xNXlSaGkon7sf1GDR/Ae18WyKm/mp/cNcpSvUXkLdxQPT9w9rJrdLeE6emL2uIxvc30rQElg5TIyflRd6M6MrhYPaOUD0/EaqYLqlEuBS7qsllatPL0Bg5T7tD66WwjiOp5Jp82siXNwVSXK+8MDTs8ETyHjrwBFxhIGfooLs7TRuWcBpVuFPJhbPotlygqM1auVNSrHLRJ5B8WQMzKJBaGqEKogeqUM0RE7Hf6JxIepjpopqo/HMf3AC36Ui5xqAHmlqC4wQ3YnMScJJpMsxLs4zkP18sG2K5qZvnEMFKK+bvTpF3zJMh+8HHa7qSu8LBzwUTGmSKCpF2KE483Bdlpa+d/PZOrXVWHT1/DxVOVLJfEDA1NreYUGo0zNsIYjeUxL53XAzV65mhul3gm6cQK/zd0C06J00q5TYILGJPgEKiTSm3ceMQI84O/D9cWfGruJpgB1QDXVdvOtFN0Ayl2YyOsmTTGg0VyLKkRJBEsfJT5Hi36i127g8W+PrrT2FRJ9i0oYVqe2mm/YYqfCVDVbY5prko9B2Pg8zi3YmBgSb2WwNqcKEU6AoEWppLSXlA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(7416014)(376014)(18002099003)(11063799003)(56012099003)(921020)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RMbQy9kayRVkk4Neg3UvjdVKuTy0pfHlp+z4RvI+AHAkhGVvZfN4a+9g3ImT?=
 =?us-ascii?Q?rCjoLfINY51p3RiG5EnWR5IfXX1mbSWX0eg5UOZ+RwJQHCMPEkC4ZvX0RbqW?=
 =?us-ascii?Q?ZDv1VDy5U3x26ZCQ6P1lFIJ6kas6S8rjtpuotGL43QwV/7NKKNwt71JdN/+w?=
 =?us-ascii?Q?nXnDEja/Y9TVBMeBGkj2DPTtSyKWXgrqpszyO12e7lBT+vJzvwdEKvjYDpQR?=
 =?us-ascii?Q?p9bhRH6mQHoI0LWSrGlMWBFvCeSsZn977uUu7qGVXmW4B2XlPM+nWzDXjQw8?=
 =?us-ascii?Q?h0oLC2zsbHr6lm35WteCE/wudh/BJYBYa4eAaWQj82II3n0mb+5Wa5sXyQ1d?=
 =?us-ascii?Q?drK4MAXYgmV2GdhttsPgMwrJRSim2x34VZgLXLhd29nB9pMlyNCn7plkVVJh?=
 =?us-ascii?Q?t/WbIRIPnNM+3MRS3bmgcQ8dQjkO8CDcpStR+lUSbVT1j6krkXT+MP8E+aY0?=
 =?us-ascii?Q?q2fNItCs+iHKOgFePFqbmw1ml2rLRYIUZ24PfS6HqHQ2tdC0MZd8FbGLFL+7?=
 =?us-ascii?Q?U9KDJVIdfQMFqMrX+4Gyf+e5phAN4M9+KL/WFj5FzwJv03cJ9Lh24rwBUwO9?=
 =?us-ascii?Q?GjWTBBLkxGK6f4pjCGB5y5orssndB3FqiA0Kp+FVV5qPy442uHmQ+zSrzx10?=
 =?us-ascii?Q?DvOpD81ImvJYrBR4noSobS9ln+svY7w2tftqKYxTDj25MmbvW1BK4BjjrPMk?=
 =?us-ascii?Q?xcPqbIefYqtNdFns5G2eV9t0HNqIfZRh/8rlfE9wSot5jzcINMgr5P3wZvLi?=
 =?us-ascii?Q?/OPPQ7NExrOW3TtRjr0hxmG8dw50oor6wIdedDssmxSQX4OqUIab/ERgrwYq?=
 =?us-ascii?Q?j9AZiQMwiD9bD8YDew62pynJLnR3IykCGhR+ANfAp3mOszKe4anGT8T5ZxaM?=
 =?us-ascii?Q?mSInnOHGAS66cGkPuahG4DpmhmPwKuReke3QuW/omgIjzA7qV8ouE92DGPwx?=
 =?us-ascii?Q?ivsJCPJiJqaWLNCML4IABRCVJyWhmlXSqahmcWCPT4obOA2YWws5zxtDmNnS?=
 =?us-ascii?Q?OyimS0ggdUgaI3cI4iA5w9pN/IDF+HHDec6DkdLSeK+L4yEm+EmOHUyexpZz?=
 =?us-ascii?Q?UdYG0P7hZLNa6g3okuAY2BsTe324T0jz+x4xHlNIbqV9GU+PnwYZn21fpZyW?=
 =?us-ascii?Q?W9FapYAiuKBrdb1NtoBo79geZVdaLPXx+OQzUZ+kYJotoC3gGjdvX61Ohjrm?=
 =?us-ascii?Q?ANNWz5m/VCjYmHY/bjB+sO4zB8RwcDSo1zEB5SJArNsLmQr8F+LQR6N66lJj?=
 =?us-ascii?Q?kVgXXWXtuoQ99LKBbfgETLFAUQ2wo+nSlSm89LN12vD/IS5ssWoY0T8+fBD6?=
 =?us-ascii?Q?WmsgR4yTls28+PrgOAUcbDrLXzZzbWYkAdHVn3J34KWEc9KXc9c1zZ6P0vA1?=
 =?us-ascii?Q?zx4AqboP+gU5w46JWy6nPvoubsqOg7+bU5iLDzz2N6OWCrEf73VoX83mBl1x?=
 =?us-ascii?Q?sTzln4SB+EsSf7nNpECFzU89+jnYFFzsixUeN74iyZMgv0ySyiXL2oaYTSda?=
 =?us-ascii?Q?Rz7+KiP6XKW0+24l9srIZcIWHjC1gH+G2/JWU1BElks6tgLBc/N+xv1f+a8P?=
 =?us-ascii?Q?L2mmufnBgkkPA1lhd/oM7Yy1xz/jFQ5J3Aiinyz7gCWnCmcvsolX2bX5Gs7w?=
 =?us-ascii?Q?cwn7H/rgAC3lOUpCZqkQZouBQxCQZLkbgbiEixBUOGACgqpkm5tK8NrbD48s?=
 =?us-ascii?Q?4lfRB/PRIVgtK/bmIhVYmTayBeLg82qIxFOVtpTxypyyWuLDNN+Lk5jC6/oe?=
 =?us-ascii?Q?9ooJQDHBlQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62f40f44-8edf-4f2d-36ed-08deb0d70e0a
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 10:04:43.5145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oE6evvToBBIWGicIFqisk0qobIHTwN68dxv2JK1qdkASByv4ccaCYtjVltbBtDWCtpv/ol9kkp3+TQdIW+JBXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB5884
X-Rspamd-Queue-Id: 3072D5311EC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-1602-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vivo.com:email,vivo.com:mid,vivo.com:dkim]
X-Rspamd-Action: no action

From: Liao Yuanhong <liaoyuanhong@vivo.com>

F2FS currently avoids inline data for encrypted regular files.  This is
because inline data is stored in the inode block, outside the regular
bio-based data path where fscrypt and blk-crypto normally operate.
As a result, devices that enable blk-crypto for encrypted file contents
cannot use F2FS inline data for encrypted regular files, which wastes
space for small files.

This series adds support for keeping small encrypted regular-file
contents as inline data.  The f2fs side defines a new on-disk feature,
encrypted_inline_data, under which inline payloads of encrypted regular
files are interpreted as ciphertext.  The payload is encrypted before
being stored in the inode block and decrypted back into page-cache
plaintext on read.

The fscrypt side prepares a software contents-key transform even when
normal file contents use blk-crypto, so filesystems can encrypt
filesystem-managed data regions that do not go through bio submission.
The new fscrypt helper operates on fscrypt data units and leaves the
filesystem responsible for deciding which filesystem-managed byte ranges
need this treatment.

The software crypto operation is limited to the inline payload.  Since
these files are small enough to remain inline, the expected read/write
performance difference between hardware and software crypto is small,
while the space saving from keeping the data inline is significant.

The feature is guarded by CONFIG_F2FS_FS_ENCRYPTED_INLINE_DATA and by the
F2FS encrypted_inline_data on-disk feature bit.  Filesystems with this
feature set are rejected if the kernel lacks the config option.

Hardware-wrapped keys are not supported by this initial version. I would
like to discuss whether this feature should remain disabled for
hardware-wrapped keys, or whether there is an acceptable way to support the
combination in the future.

The f2fs-tools support for formatting filesystems with this feature will be
submitted separately.

Basic testing passed.  Encrypted small files can be kept as inline data,
and read/write verification succeeded.

Liao Yuanhong (3):
  fscrypt: prepare software keys for filesystem-managed data units
  f2fs: support encrypted inline data
  Documentation: f2fs: document encrypted inline data

 Documentation/ABI/testing/sysfs-fs-f2fs |   5 +-
 Documentation/filesystems/f2fs.rst      |  27 ++++++
 fs/crypto/crypto.c                      |  63 +++++++++++++
 fs/crypto/fscrypt_private.h             |   3 +-
 fs/crypto/keysetup.c                    |  59 +++++++++---
 fs/f2fs/Kconfig                         |  14 +++
 fs/f2fs/data.c                          |   8 +-
 fs/f2fs/f2fs.h                          |  37 +++++++-
 fs/f2fs/file.c                          |  24 ++++-
 fs/f2fs/inline.c                        | 119 +++++++++++++++++++++---
 fs/f2fs/super.c                         |  12 +++
 fs/f2fs/sysfs.c                         |   8 ++
 include/linux/fscrypt.h                 |  28 ++++++
 13 files changed, 370 insertions(+), 37 deletions(-)

-- 
2.34.1

