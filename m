Return-Path: <linux-fscrypt+bounces-1736-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id iB13ANO6Smp8GwEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1736-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:13:07 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D66370B49A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 05 Jul 2026 22:13:06 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="AGFGOhk/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1736-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1736-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2E1163004C58
	for <lists+linux-fscrypt@lfdr.de>; Sun,  5 Jul 2026 20:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5F1F35B645;
	Sun,  5 Jul 2026 20:08:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97632E719B;
	Sun,  5 Jul 2026 20:08:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783282101; cv=none; b=VbkDJssylusuR9X8WR1G/m6GAVZIoQqoxPHNmU7FJPl/6sChR6mugLdoobglanWDxKI1/JZ864PMndjL3bMbVASdRTMbQVmCQWwSPcZWO0Yg3sw1moceC37EeKJ3QQDVt78IUyA3WQozPgI88h3qGq7bsA7CwyYbMcyR/rNsPrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783282101; c=relaxed/simple;
	bh=ZcpRYQMpJQ3+6XpwxEr+ScC4qW5lTO+NAfuuFR/Xi14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4xMpzgoW8dOzFfj4A3EhTXQICpnD57DISopVMvdlIyjS7vYDXNrH0DIpWaQ2agdpb2IaUCDQDJRCtPFnAYs+OdGfNxMQwSjWK/dn1/FNid2Qv7aZYogxBbdVz707jIayz92+W67rCKkosdVlvdmxOB9SnJ3xJHGIfMhf31OhO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGFGOhk/; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998341F000E9;
	Sun,  5 Jul 2026 20:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783282100;
	bh=9CM2wVbhyHLDtHdcSbwHJ5tP/f8SZ6JkBBSxBmdPEIY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AGFGOhk/VoXIOfqZakNksTm9cB9kUoQy3LTGkLM0HcAPxl6/kIl3CzWgnpVmQX247
	 uX66+jr6L+LgeQifhoIeIf/X9WbbF4u6YO2O224FtIdR88BYvhJXgBVErqAv1qYAQG
	 BrBPNqqepnxhkahgILgJluwb8nqXRvfTpdmd7b0PCOPPOfWJt2NqqupFD8aebiy8XU
	 88n644xK/cTr98yc1ql5fZt0ZouO3k+FieKZI8yxhs49BQY3tFy6EP5duynfslihcy
	 QaJ7HPjV3Mobx0ZWqgxUl2C7b+E2QguMK5ODWC/FI2mMgzvTwY/ybiqGJcQg+fd5wc
	 891wd3RQZ/kUA==
Date: Sun, 5 Jul 2026 13:08:17 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>
Subject: Re: [PATCH v2 02/17] blk-crypto: Fold __blk_crypto_cfg_supported()
 into its caller
Message-ID: <20260705200817.GF41916@quark>
References: <20260705194555.75030-1-ebiggers@kernel.org>
 <20260705194555.75030-3-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705194555.75030-3-ebiggers@kernel.org>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[15];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1736-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,quark:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2D66370B49A

On Sun, Jul 05, 2026 at 12:45:39PM -0700, Eric Biggers wrote:
> __blk_crypto_cfg_supported() is called only by
> blk_crypto_config_supported_natively(), so fold it in.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  block/blk-crypto-profile.c | 22 ----------------------
>  block/blk-crypto.c         | 23 +++++++++++++++++++++--
>  2 files changed, 21 insertions(+), 24 deletions(-)

Sashiko pointed out that I forgot to remove the prototype of
__blk_crypto_cfg_supported().  I'll fix that in the next version.

- Eric

