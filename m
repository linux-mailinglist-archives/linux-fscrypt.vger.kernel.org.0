Return-Path: <linux-fscrypt+bounces-1533-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OPgoJp6Ot2muSwEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1533-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 06:01:18 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 28F21294B01
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 06:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 563793006166
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 05:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5BA1E5702;
	Mon, 16 Mar 2026 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YzlsP9hH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010000.outbound.protection.outlook.com [52.101.61.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AAF23741;
	Mon, 16 Mar 2026 05:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773637274; cv=fail; b=h9iHOt8VmVj5MhwBDvnxinbRAwiQ8yjpbSP2/whdjm96xifzRYGrUpE/R5FCy+KQIUtZN1nojOlrhrEtMJI3gjlGNjEMlI5k6mJXIM362WR4JONMSEuMEqlI6H4BJmitrawkbYVTBAjtfL1G3ihlv3Oh630Ey2pvogJd3s4DHPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773637274; c=relaxed/simple;
	bh=g2OLqor03pOLFXxKKiyfQ5q/HSkefFZCfMusDZXYdhg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mfsCg+Log0+Exqe0X62zG6Ut3UgzCEdXCt1/yMzeWSazdh1ngD9OWZ0ZS8yakCezKjZeLd9nwQOGz2SJqZwG1B5SeK/o8F/BBD0i+r3OqQCFyNAtppNEubIyjxTEkFuF6YTfn5H7264qnzvofkC2LhzzWmsxavqD1tPmT1JNrX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YzlsP9hH; arc=fail smtp.client-ip=52.101.61.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SUOVGqkP3n7mbCZkDY1Un5rvE6+Iy2D9u0eftNVwGyh4k3/Qn6fihHAjb0p5roCI3qCiNRNl+pC9fSYmbv7K3XUPqlhPuLNa7QGzjknTJSRTXU0uEwxkA4YZ+kF8/2bm+tYgrP3Y7Seu8+0QhO6hf3J0+Jtr/PHPT7G+/a+yKlOZm4RxKpokkVjmmUaRp+qts4zvFxY/racPvmwPcMtqRbA+txkzMhPAgCSEui5u0ei0H2SGhYN9nP+LTEONJ/xw+BK46se+HzouLVcsYVFOPxCH/2d2nBmSihiL1nS4732YPdJqeATrbon3CL3WjouPp+n5R0A3xoNBitfGfv9r9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YaH5NcpaeD/GgaCWwb1SFJni/VKMH3UsM/YQzowjWh0=;
 b=P41LaT8K5wPA4aSRD1685d1upsG/4Vsm1j2PgBbRH6qWlU8O4wl70QlqxC8t9GmbmH5rClR3OSGn+YoDECiaT6zym2YkpytQKAKWIshdOo/CkxKdN1UCY00UhGyK8xoJp0lenfAqEjUoUYpvtvqAdmifB0686f0gNUEBHV3WdnTVEtyqoSPAXqqyW6iPQGdlTSuB/iNaIOkvXqYD8FF+SRYKxP7XOe7eY9BtEUv0vCWWCJMskiFtxtIjkoMOL6E4MhhkQM1mftFEDOM7aBqs+EM3nBZbxDvjMvnlWGpmuTT+VHJDuwF0DvA1Q8rvEgML+HFsrs3u0LlzVz3l7BVzcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YaH5NcpaeD/GgaCWwb1SFJni/VKMH3UsM/YQzowjWh0=;
 b=YzlsP9hHHRoTFieMsLTbGSNQh+Ab9YEMztovOaRiM6gpwcBS+INfkOTDgCN4FQ7Ca9FOIgmTLRGfv69REdr5Mr7LmVHveBkKjdSC0IDV/gx9DL05skFTasXp/h58o32UjbKDyleC+VWkB8iA3s/XPdTnReFOqn2C/yugkcv1aiDJ0hdy36sncotW/ncSyAEgGbohw2E7oI7NEUopm5iV9Wk6jY9cAnSqAvYGpm72ph6siXEiVruxuc5HpSzxv/6wxcu7ZqeTN19pZS9vSDhwABMf6tXZrHXvXdft2aqFCK3nO3oXBgoUPG5Ky4lU8r7YsjFe01riqnyNkTnF9tuGOw==
Received: from SJ0PR13CA0212.namprd13.prod.outlook.com (2603:10b6:a03:2c1::7)
 by CY8PR12MB8065.namprd12.prod.outlook.com (2603:10b6:930:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Mon, 16 Mar
 2026 05:01:09 +0000
Received: from SJ5PEPF000001EF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::b6) by SJ0PR13CA0212.outlook.office365.com
 (2603:10b6:a03:2c1::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9700.24 via Frontend Transport; Mon,
 16 Mar 2026 05:00:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF000001EF.mail.protection.outlook.com (10.167.242.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Mon, 16 Mar 2026 05:01:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 15 Mar
 2026 22:00:55 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Sun, 15 Mar
 2026 22:00:54 -0700
Received: from BUILDSERVER-IO-L4T.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server id 15.2.2562.20 via Frontend
 Transport; Sun, 15 Mar 2026 22:00:51 -0700
From: Akhil R <akhilrajeev@nvidia.com>
To: <ebiggers@kernel.org>
CC: <akhilrajeev@nvidia.com>, <herbert@gondor.apana.org.au>,
	<jonathanh@nvidia.com>, <linux-crypto@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
	<stable@vger.kernel.org>, <thierry.reding@gmail.com>, <zlang@redhat.com>
Subject: Re: [PATCH] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Date: Mon, 16 Mar 2026 10:30:31 +0530
Message-ID: <20260316050031.31089-1-akhilrajeev@nvidia.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260314165515.9678-1-ebiggers@kernel.org>
References: <20260314165515.9678-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EF:EE_|CY8PR12MB8065:EE_
X-MS-Office365-Filtering-Correlation-Id: 1202e689-5230-466a-9870-08de8319094c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|36860700016|7053199007|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	LmPTB7TMfnVoqxz0GsFokBlZi9dZgcP+srzcWrxvtBOMTYtFMUoLeHBwiUxCKNCx+cJMMgK71aU+hzPk8A2MZoP9RJ7QdJ5KyX0x56SzmK6krtH2NWJgYwB6ntXNKMptKX3dW81xMZqTntcPSUQE+H9uymwdspHFvyUNlD91wMXRsUYfId+lkJ++Rr9Lq9eNZzGljwx7tE7CC+TIEHZ8VjR3sO4gOXCV7GlIuNzfnrea6gXx/KnBDsJlVfRtDAig1ntGYklaKjg85qpqa2RnBGgfMXHT+9AptGcTKkuPoguOTC6cBJJsoU5UaGuT+6+qwNYxtMABgcGXoDF2BHaCqbTVst2NiV3lFypnoQMBQZwq/sk0b9tX+BwWjNnuaXcOx5VI8oqW74EdAc7Bsw2KDGt8gqtW/ma/ngY0XIyDfze3KNPUDOUxXB0en4rw1ar9mXmhh19vbK5XKJpGGx9vNQScZmJPWCZ6MnAYHOf7YRKNn5jWWuN6TX3I/UklvKUfSPpqTuazSxFhhqYv3ZJ631mAp44/3wLYk6ZRcZvTD9RRxGDUWztyUKc7Ty3+R4XUAGHiKOM43uO4r8ybgn4hQDwPeqg47otrCgDbxKoloLanOnTCNsn1Yo6u9w8tqOSB7Rk7cqyD25WI5Znm15Av54O/r5s+Ijq2SUe8x3B6kzkqA95CPe/qppJvW07euORFkTujB6HqMrYVOIGYAmT30crm+YE+Z/zZKv34qJZOC6a0R1Vhydu6MjegWBAEjEwt9UvSryTNbwagwHVPGUkzsg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(36860700016)(7053199007)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XpVb06Y76SWZNcFEW8mF0AhGZtIQ4R8lEDVbpe41bFS5ydXjmPOn+6eDArGGcZKjyblgiEEoo4/vkRhua9eldYg1WEC+Yk/EXKD0vWWWgM4pNw9FeHqU6+0salypDU7GPqgAV22qK7zpTVnruvm7KqZ+/HGlGU+65CY8aBYM9lrcRdsWMYm3ryuaO9O9I8TMWJqzKrEF3c6qNVo+D6NHicRVb9vbPymJJDyzN/zSGsNW9d6fsI+ugpkMGRe8LdHhSwVk7yF+luL1MLef4/6o9aoW7eXKW4ZR6NT4HKe0WPACjt16nNxcb1fTyAEyVbDOiDwB9/jGN6DXGlmRDVTbFWWVZqqzHtSqRLmKBNT/+NTB7VoiA9vuUM1zxAiNp0GUnzdS4SIIZI4T15yOL6mYGzPy9VwYICpf7cjJsfc/FEaOX6q7oq5226gjHQR2fEs4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 05:01:08.6253
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1202e689-5230-466a-9870-08de8319094c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8065
X-Spamd-Result: default: False [2.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1533-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[nvidia.com,gondor.apana.org.au,vger.kernel.org,gmail.com,redhat.com];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[akhilrajeev@nvidia.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,Nvidia.com:dkim,nvidia.com:email,nvidia.com:mid];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 28F21294B01
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, 14 Mar 2026 09:55:15 -0700, Eric Biggers wrote:
> The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
> asynchronous algorithms, causing the crypto API to select them for users
> that request only synchronous algorithms.  This causes crashes (at
> least).  Fix this by adding the flag like what the other drivers do.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Cc: stable@vger.kernel.org
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Thanks for the fix. Looks like CRYPTO_ALG_ASYNC is missing for the hash
algorithms in tegra-se-hash.c as well. Would you want to include those
in this patch? I can push a separate patch if you suggest.

Acked-by: Akhil R <akhilrajeev@nvidia.com>

> 
> This patch is targeting crypto/master
> 
>  drivers/crypto/tegra/tegra-se-aes.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
> index 0e07d0523291a..cb97a59084519 100644
> --- a/drivers/crypto/tegra/tegra-se-aes.c
> +++ b/drivers/crypto/tegra/tegra-se-aes.c
> @@ -592,10 +592,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
>  			.ivsize	= AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "xts(aes)",
>  				.cra_driver_name = "xts-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize	   = sizeof(struct tegra_aes_ctx),
>  				.cra_alignmask	   = (__alignof__(u64) - 1),
>  				.cra_module	   = THIS_MODULE,
>  			},
> @@ -1920,10 +1921,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.ivsize	= GCM_AES_IV_SIZE,
>  			.base = {
>  				.cra_name = "gcm(aes)",
>  				.cra_driver_name = "gcm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1942,10 +1944,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
>  			.chunksize = AES_BLOCK_SIZE,
>  			.base = {
>  				.cra_name = "ccm(aes)",
>  				.cra_driver_name = "ccm-aes-tegra",
>  				.cra_priority = 500,
> +				.cra_flags = CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = 1,
>  				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
>  				.cra_alignmask = 0xf,
>  				.cra_module = THIS_MODULE,
>  			},
> @@ -1969,11 +1972,11 @@ static struct tegra_se_alg tegra_cmac_algs[] = {
>  			.halg.statesize = sizeof(struct tegra_cmac_reqctx),
>  			.halg.base = {
>  				.cra_name = "cmac(aes)",
>  				.cra_driver_name = "tegra-se-cmac",
>  				.cra_priority = 300,
> -				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
> +				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
>  				.cra_blocksize = AES_BLOCK_SIZE,
>  				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
>  				.cra_alignmask = 0,
>  				.cra_module = THIS_MODULE,
>  				.cra_init = tegra_cmac_cra_init,
> 
> base-commit: 1c9982b4961334c1edb0745a04cabd34bc2de675

Best Regards,
Akhil

