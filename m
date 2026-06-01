Return-Path: <linux-fscrypt+bounces-1613-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GDytEnGfHWqncgkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1613-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 17:04:17 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B54536214F1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 01 Jun 2026 17:04:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A0EA6305D13B
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jun 2026 15:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B8053D7D69;
	Mon,  1 Jun 2026 15:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b="eNg5aHKa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012025.outbound.protection.outlook.com [52.101.126.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D63BED56;
	Mon,  1 Jun 2026 15:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.126.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780326083; cv=fail; b=XhhoNCp6jjz4/kT5z1srIbU7OjfTpfDrRDC8TNGrRgqWcE7XY6m/Ah2pSS3f/ShVOa0YNyBeV5kHx6/0U8vweseDb5IG7oAs1kKbzsAkuji7WYc55l9Z4aAKqvApC7fxsGN4hptqVYztjCMkTyfScXx8GC3qqcg6vAxh/yS3qxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780326083; c=relaxed/simple;
	bh=CEeJDA/lATCvBW+Kofkrc8cHKWsMXhQrUNuZJb5xpls=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WkxDD+gfXwJqZQzW7f4Ai0wLUUJgqPDRmETLKd8GwtN+2yE5ub5GKiCxizLAPkRrbKBxfXwBfsw8Saymy9ZQvaaOIwDnMrNovUZwLN58AlUZ0UOzPdYaJ/+XYSYfSMuUcPtckLe09Sesok9P/TrG2CHans3940XGmC7ACb43yxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com; spf=pass smtp.mailfrom=vivo.com; dkim=pass (2048-bit key) header.d=vivo.com header.i=@vivo.com header.b=eNg5aHKa; arc=fail smtp.client-ip=52.101.126.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vivo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w4KGBBXEh29GmJPhWMeiqqLZZWUCMg8MiZO0IyClm3o81tQiLl/K+2e0Gw2xvF/ZFCKbZQu+jwIJoF+B3bOIPh/YImVqJbANJhzRam8b0wQTSbQCdKvGPs27nrjoWnq1fphcuGYr5vEQQm/D+w4mWu7wwbvJkVvNiK85aZsikSoJpWfzXQEZ19Y2OSJn+7P+d6NB/K/Nzt3jPIzj8HDH0OvGHA9i6m1MOaUAXsXDu591AkGb6xmgVBj43eeYFMfFRRzRiAayGXjJmQIuZAtGV0u6oXTjwrcbf0ERQUT7rWcK7hB4RknTdahz5Tti57uPP267Lmnh8by+mARv1uONiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hryDbLuo2gsMXs8ywO37i6j8EBDv7DL1o4w2kUC5EdM=;
 b=ZkBJ90G+o6Wa8TAQCjrw9TIvNF+RzFcc80N5lmbtjlkdiFOmhJejpAk0Atz2x8dn5lQnlDc8Hht0KfXH/lRTZNkxIPKSHu49O4o5I1NzzRdKWmxmjEHzQOrPy2AFvk/DhOZ7i7Sgz7oAGFGVgVd1INSkNy8EUbFgii+S2Zry+ryn0d3dc93czQ8+Sl/SHos0+mZblOHcbON1l5AHhRsIJjIKORScLkefRdtQpce0Cu1tOWhpJxCdyO6b88q1izhgpbtd8JSvk2lPSomDxvHitTUS6NOdVIqE65mqGMdaJ8bm6EdhNOR8bLKQh8qfP1s2l43+QBEFPbdaKx/MAQLBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hryDbLuo2gsMXs8ywO37i6j8EBDv7DL1o4w2kUC5EdM=;
 b=eNg5aHKaGrfh83ul2FZkacxc4bL1M2mRm3VZsIXkF+8h2kdONV0oz1I4V1maWYm3X0FOQ5XPwtmV4kIFbZDOiye9BbGihbVXGdbDblpx+nh3eh0pUc0jXIMG/QbATpV95HiIxzrGjCC+pj6DLhDpk6RpWjhS9snWY24vvwFJW0hkT6AZXvO6eEQFPEQZ/0XT8v/huk18E6IRlo1iHaVUFaF/bBA067ho3fsJl45UTzwNTbAYO/uqp1dSZaDczstE0zyhBWODYt8Jwk5hy2i8GMzuLFJugGJvVOYrjxbQk9rR1nS1IvnUyUpy+5Cc9+6CLh6gISJRqWp0Br1Ogf/IdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com (2603:1096:101:c9::14)
 by SEYPR06MB6335.apcprd06.prod.outlook.com (2603:1096:101:13c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 15:01:17 +0000
Received: from SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96]) by SEZPR06MB5576.apcprd06.prod.outlook.com
 ([fe80::24bc:5613:3ffa:cb96%6]) with mapi id 15.21.0071.015; Mon, 1 Jun 2026
 15:01:17 +0000
From: LiaoYuanhong-vivo <liaoyuanhong@vivo.com>
To: ebiggers@kernel.org
Cc: chao@kernel.org,
	corbet@lwn.net,
	jaegeuk@kernel.org,
	liaoyuanhong@vivo.com,
	linux-doc@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org,
	tytso@mit.edu
Subject: Re: [PATCH 0/3] f2fs: support encrypted inline data
Date: Mon,  1 Jun 2026 23:01:05 +0800
Message-Id: <20260601150105.350833-1-liaoyuanhong@vivo.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260515184124.GA4903@quark>
References: <20260515184124.GA4903@quark>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::7) To SEZPR06MB5576.apcprd06.prod.outlook.com
 (2603:1096:101:c9::14)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SEZPR06MB5576:EE_|SEYPR06MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bdae4f2-466f-4140-4ec8-08debfeea1a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|376014|7416014|366016|38350700014|22082099003|18002099003|56012099006|6133799003|11063799006;
X-Microsoft-Antispam-Message-Info:
	YJcHNOX+q2RLayg9DQdXOpxYzwR73ZxJkXiVcx1o/2iN6YRRRYpMdFo0iqEV26meFAiXBLKX0PUKdR6fMtXqpXL0Q6oO+j14jAYKcl8KlQyzAqsvV64IwX09+ShAyIedAfsjwjpSsylgo1gLCiCrESCHs8HGe+acjXkXvtbe8uGssIrPdyd1kcngtyKBYuhZBAUqShpvhZlEACWZ+/Y753OSXp6fDekJaMszwTErbuuNNR/zd1CwyNrjJgrXbH/wJehgB2t8lbIlvfdXt2S1ZU/nKafHs44bRoQB1GumFVE8DBSoXTMrpCQ7fPsnXy6PoWBXS+K56/wRcWSXU3QNQjMn61SfXWbv4oaS6FpGq/tl+kLT4FPJTPixm+pm+ajuNz1cUYCUGZDKvUwfa2s6apTg27J6UrT66BLmQtJTKcWhirVyAz969zRSMPka1NnnTN60yeZ9UWVLYNzMRt7Up6GeDwBHZHD8VsEmkAcZ9jzXuXJys/OZb5AhhT+IMnREVOGIULuw0/A/3l5Hzrsdf1rv8iDjW+Ei2PzAH76sZZuBAryp48kATJS/pqSxmyWxLaXG+XrN7bTiVOwh88LDwNrT61EvgPPrwcWejToe/c1ksaylyTGD6sxTreBkyVODM1mOCAf5oNm8uvi1Lkstte5UAPgCKMOYMajfjSgSuZE9pk00HUK8ki0uNsZPReEu
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SEZPR06MB5576.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(376014)(7416014)(366016)(38350700014)(22082099003)(18002099003)(56012099006)(6133799003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7J6EZZg1Ab7X0SumqIb/fBah9muEL3a07cyc1SOSORznZHFXVattO9olApxa?=
 =?us-ascii?Q?rev2bj/97cKOTxMObmqnQE3XP3OsuLfx/PWVqfcFGHa+wOegWMvrzYM8Nkxq?=
 =?us-ascii?Q?J6MsoHHHnnyYMwJhZ5HN3A3CErVU8rBhM8SinQpF5tGWG3KLdlxSXr07qJ1x?=
 =?us-ascii?Q?mTTn4Ir0sW3MWFBjtGIK4p1QckQyOwjTNW4B8dZePg40AY1XkwcKZG2qnVlx?=
 =?us-ascii?Q?eWVxOMOxbU9i7ckumcTzdG5JSi8B5c7qwb/JHiLwQiPUCZRhGGpWOPEQIk71?=
 =?us-ascii?Q?IiJgaz1g0Ca2XcMCxIp3KH6NbCOD/bQFi7I9kuuFYaQwGLuY8G8z7xETUW78?=
 =?us-ascii?Q?n89wfIjkXr0w5HTg3AUfXQ3EzgE9Acf7vnPuqXmVG834nQQKNR0otqEDX51R?=
 =?us-ascii?Q?GGhCBVHHc9m5V0zJHhv6kNvefKa1ruOw3oJWHitKK5OL1bFU1ubrBru7LvfO?=
 =?us-ascii?Q?a5pt5X1hszy9y3HvSw3/XsY76HBsL53ud6qQqzQgIAftK/9QnuV8LqQOJeyF?=
 =?us-ascii?Q?mwQ1B3/xtZfMEmgdlLTBsgPG8VyOk4CR00mceHxPbp5tyQLyX4J4rhOILMQf?=
 =?us-ascii?Q?BWf867TEQ495VwPed11bz8zNADZ4tzDwOctzAiTMHLhxAQqRTEQMrD+dGrT0?=
 =?us-ascii?Q?y564xbBFOJQIQS/05qBPK5IkU7F3alu91bs7qri3GBbxh9mQ+R4rQXOQsoEU?=
 =?us-ascii?Q?O5I0DTODDQF3WU4Z/x3HUn3B26D0o4DbpBcg9gK2eIJvq/y9JM7Q8uaKmCZR?=
 =?us-ascii?Q?YY8vKDzL50J8ckapyShygVSzSK99IWn8yMHta97OUVUYbA/S7akzhFYlhl9k?=
 =?us-ascii?Q?A3qJDMO+d5F1PYy1hc8bEN1A66pSBtcR1hElP/qVSxbMEJ5HtHWJsdthfrrB?=
 =?us-ascii?Q?xlBK0ohM9X31xccyykyVyBA947cltK1yTh82US8sw2VC6qzmAwY8RsPIHU6/?=
 =?us-ascii?Q?AWEvSfUM0tZsxXySNCK3zXjgObhJyAFcXRD2bXS7iIrt8EIPx2V1yDbbNY8a?=
 =?us-ascii?Q?x/OuFhtoMYZVj/x+J7uJ0q3ds3pAVRaB71fY56cZrGfHZkLRX66alNL/zBiS?=
 =?us-ascii?Q?tAfQ75bUuTbqsGE3/1VsiRsTGk2WS2oS/kuZs0mkvu+LEJ7mC01ktQa/3LQj?=
 =?us-ascii?Q?aZ/Qv92d3tNaJ2FANVlQUZ0DZWgBH0eC3sHaE5+8oclKWcv6OoTYq8hVH0sA?=
 =?us-ascii?Q?nMIJXzn4k+D9jQVY1NhBQtb2OvpUvIczpNbjLx9FxKOT9lh/XC7icWj2zjmQ?=
 =?us-ascii?Q?n+gYATSPGvULjGkBwDuYHexio3PrqpW/7U9W5lYSIKA3JkojJTJwaOTusVOy?=
 =?us-ascii?Q?bRXsdIKiHEQdCa7SXMPquOkSaWGxYTBMpYJaxc8PsUvGDPXfud8MQSJ/RpCm?=
 =?us-ascii?Q?1MesZfb33IdAiI7+W3lWJTaC+9Sc1HwQqsOKt2wLVN4/OncEbT4EWV7XaSDS?=
 =?us-ascii?Q?90T/4S/Rty0R3E9X5wAhYs5USzxnO61bespR896xXCIJrX1zEtadjJFjuOX1?=
 =?us-ascii?Q?LwxgsPvTgaJj3yUbzdDlXcjEXo3C2rMwrseJ5le4+bWS3Zd4IB1Ky2+Ku9Eg?=
 =?us-ascii?Q?jW7Y4315H2LQJeURanCbMdAfxWfRiwc/qiTDnzvHVJbvQLJ1pGaU6Deckm9L?=
 =?us-ascii?Q?kXrvDXA8Z8N5AxEKmfaNtM1nIInQ6B8U7ND4F7/vHcVIyJuUmvCMBut9U1NB?=
 =?us-ascii?Q?NFJBkiyju4zCDIZ5ijsNWRJ7qvPqi7k4B1vOahrBZXtk1Rgv7QcXsd18A9kM?=
 =?us-ascii?Q?W3N4tCrY4g=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdae4f2-466f-4140-4ec8-08debfeea1a3
X-MS-Exchange-CrossTenant-AuthSource: SEZPR06MB5576.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 15:01:17.0804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvwia7YrtpYnJznxlYRmpLnfXt44738SXMmhkwi0vuOULn1U5B/mdRplTUR+n7Y/t1ecktTK4UHrevx+CT9DfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6335
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[vivo.com,quarantine];
	R_DKIM_ALLOW(-0.20)[vivo.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_NONE(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liaoyuanhong@vivo.com,linux-fscrypt@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-1613-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[vivo.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.986];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vivo.com:email,vivo.com:mid,vivo.com:dkim]
X-Rspamd-Queue-Id: B54536214F1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/16/2026 2:41 AM, Eric Biggers wrote:=0D
> On Wed, May 13, 2026 at 06:04:27PM +0800, LiaoYuanhong-vivo wrote:=0D
>> From: Liao Yuanhong <liaoyuanhong@vivo.com>=0D
>>=0D
>> F2FS currently avoids inline data for encrypted regular files.  This is=
=0D
>> because inline data is stored in the inode block, outside the regular=0D
>> bio-based data path where fscrypt and blk-crypto normally operate.=0D
>> As a result, devices that enable blk-crypto for encrypted file contents=
=0D
>> cannot use F2FS inline data for encrypted regular files, which wastes=0D
>> space for small files.=0D
>>=0D
>> This series adds support for keeping small encrypted regular-file=0D
>> contents as inline data.  The f2fs side defines a new on-disk feature,=0D
>> encrypted_inline_data, under which inline payloads of encrypted regular=
=0D
>> files are interpreted as ciphertext.  The payload is encrypted before=0D
>> being stored in the inode block and decrypted back into page-cache=0D
>> plaintext on read.=0D
>>=0D
>> The fscrypt side prepares a software contents-key transform even when=0D
>> normal file contents use blk-crypto, so filesystems can encrypt=0D
>> filesystem-managed data regions that do not go through bio submission.=0D
>> The new fscrypt helper operates on fscrypt data units and leaves the=0D
>> filesystem responsible for deciding which filesystem-managed byte ranges=
=0D
>> need this treatment.=0D
>>=0D
>> The software crypto operation is limited to the inline payload.  Since=0D
>> these files are small enough to remain inline, the expected read/write=0D
>> performance difference between hardware and software crypto is small,=0D
>> while the space saving from keeping the data inline is significant.=0D
>>=0D
>> The feature is guarded by CONFIG_F2FS_FS_ENCRYPTED_INLINE_DATA and by th=
e=0D
>> F2FS encrypted_inline_data on-disk feature bit.  Filesystems with this=0D
>> feature set are rejected if the kernel lacks the config option.=0D
>>=0D
>> Hardware-wrapped keys are not supported by this initial version. I would=
=0D
>> like to discuss whether this feature should remain disabled for=0D
>> hardware-wrapped keys, or whether there is an acceptable way to support =
the=0D
>> combination in the future.=0D
>>=0D
>> The f2fs-tools support for formatting filesystems with this feature will=
 be=0D
>> submitted separately.=0D
>>=0D
>> Basic testing passed.  Encrypted small files can be kept as inline data,=
=0D
>> and read/write verification succeeded.=0D
> Honestly, I'm not convinced this is worth the complexity and the=0D
> additional memory use.=0D
>=0D
> First, it works only in the combination: 'f2fs && inlinecrypt &&=0D
> !hw_wrapped_keys'.  That really limits how many users would use this.=0D
> 'f2fs && inlinecrypt' de facto targets it to Android devices rather than=
=0D
> "regular" Linux systems.  But at the same time, the "best practice" on=0D
> such devices is to use HW-wrapped keys, which has already been widely=0D
> adopted.  So this would be useful only on devices where the SoC doesn't=0D
> support HW-wrapped keys.  Its usefulness will go away when support for=0D
> HW-wrapped keys is added.=0D
>=0D
> Second, in the per-file key case this makes every file use an additional=
=0D
> 1 KiB of memory or so (assuming AES-XTS) to hold the "software key",=0D
> just in case the file ever has inline data.  That seems problematic, and=
=0D
> maybe not a great direction to be going in right now, given the ongoing=0D
> RAM shortage.=0D
>=0D
> There also seem to be quite a few bugs/issues.  Sashiko found quite a=0D
> few=0D
> (https://sashiko.dev/#/message/20260513100431.299904-1-liaoyuanhong%40viv=
o.com).=0D
> But just from a quick readthrough, anything that calls=0D
> fscrypt_is_key_prepared() seems to be broken now, as that function isn't=
=0D
> aware that both fields of fscrypt_prepared_key can be needed.=0D
>=0D
> I'm also not seeing what differentiates the new=0D
> fscrypt_{en,decrypt}_data_unit_inplace() from the existing=0D
> fscrypt_{en,decrypt}_block_inplace().  They seem redundant.=0D
>=0D
> There's already a lot of complexity in fscrypt, with the different=0D
> settings and the different ways the filesystems do en/decryption.  With=0D
> this, plus the concurrent work to add support for extent-based=0D
> encryption (for btrfs), it's really quite hard to keep track of=0D
> everything.  So I have to wonder if this patchset is really worth it.=0D
>=0D
> So, overall, I think this would need a bit more work.  But also I'm=0D
> wondering if it's actually worthwhile.  Do you plan to never enable=0D
> HW-wrapped keys, for example?  And you're fine with using more RAM?=0D
>=0D
> - EricThanks for the feedback. I reworked the crypto part to reduce the=0D
memory concern. The inlinecrypt data-block path still uses=0D
ci_enc_key.blk_key, and the software tfm is prepared only for the=0D
encrypted inline_data path. So this no longer adds an extra software=0D
tfm for every encrypted inlinecrypt inode.=0D
=0D
I also ran a small-file workload on an Android F2FS /data device=0D
with inlinecrypt. The test created 10000 encrypted files under the=0D
same fscrypt policy.=0D
=0D
Results:=0D
- 1K files, encrypted inline_data enabled:=0D
  inline sample 200/200=0D
  fs_used_delta_kb 46344=0D
  avg bytes/file 4745.63=0D
  time 430.23s=0D
=0D
- 4K files, encrypted inline_data enabled:=0D
  inline sample 0/200=0D
  fs_used_delta_kb 85280=0D
  avg bytes/file 8732.67=0D
  time 435.06s=0D
=0D
- 1K files, encrypted inline_data disabled:=0D
  inline sample 0/200=0D
  fs_used_delta_kb 88808=0D
  avg bytes/file 9093.94=0D
  time 429.37s=0D
=0D
- 4K files, encrypted inline_data disabled:=0D
  inline sample 0/200=0D
  fs_used_delta_kb 80728=0D
  avg bytes/file 8266.55=0D
  time 430.78s=0D
=0D
For the 1K workload, encrypted inline_data saved 42464 KiB across=0D
10000 files, which is about 4348 bytes per file, or a 47.8%=0D
reduction in filesystem used space. A raw inode check of a sampled=0D
file also confirmed that the inline region did not contain=0D
plaintext.=0D
=0D
To check the memory concern, I added temporary counters for software=0D
tfm allocations. Under this Android policy, I observed 3 per-mode=0D
tfms and 0 per-file tfms. Creating the 10000-file workload did not=0D
increase the tfm allocation counters, so in this setup the extra=0D
memory cost is a small per-mode cost rather than something that=0D
grows with the number of files.=0D
=0D
For the 4K control workload, inline_data was not retained and no=0D
extra tfm was allocated.=0D
=0D
This is Android-focused, but I think the use case is still=0D
meaningful. Real phones can have more than 200000 encrypted files=0D
smaller than 4K under /data. Avoiding one 4K data block for a large=0D
fraction of those files can save several hundred MiB, and in some=0D
cases close to 1 GiB. That seems worth considering if the=0D
implementation stays simple and does not introduce per-file memory=0D
growth for common Android policies.=

