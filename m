Return-Path: <linux-fscrypt+bounces-1678-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zkpHLs3SPGqIswgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1678-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jun 2026 09:03:41 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D89DA6C336B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jun 2026 09:03:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyUeAerz;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1678-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1678-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2A0A73009154
	for <lists+linux-fscrypt@lfdr.de>; Thu, 25 Jun 2026 07:01:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9ADD33A9D1;
	Thu, 25 Jun 2026 07:01:41 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28AE1CAA78;
	Thu, 25 Jun 2026 07:01:40 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782370901; cv=none; b=b/2vVKAOSQQKtbb6odTgQ/vXCLZ165sBtaw6r2PRPaBAG9xEmBiIiAvLAddBUVkPpHa0i9k+eOO7JT/U0APeLOdRL+jF2BYLEfJMcasxLmxp5R54rM220xBp9onmivmlFZKe22VKWn1w2k5Rcf69DzczPnSsgiMFseVG1VGMBus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782370901; c=relaxed/simple;
	bh=o7y3zrWWLolQ8rjHQUEvtkfJrU1SIgeSJi1z7iC+nrk=;
	h=MIME-Version:Content-Type:Subject:From:To:Cc:In-Reply-To:
	 References:Date:Message-Id; b=D4OBi3ZlVMs98QHvymNFdIZHTUJQfPEOoFwPcP/olF0YEMvy1W3gOhxQobqqJqw/GMabIO6WgWGCclVxiTi1fTEhsmfkhbVnR1C1MwYitCBE+sU4EZHpvhvdO1FRL1xv7WQKAz2G8CeObBgc5v8xnC2oGXmC1v6cLWjQ85ZLrsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dyUeAerz; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D3B1F000E9;
	Thu, 25 Jun 2026 07:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782370900;
	bh=+vv8SM8eUAW3MCRiYBMwLSNBJkmkWiJDn52oy/sEKaQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=dyUeAerzru3xhnFxtZ+CbG65FbUdOu0DgT1EdRs+Fh5nbuoTM0kZGTsrCHmZQSZ4E
	 Mf5hx1nT9BoSHOfwF5eNt2DzQ3l9GYvzQ+EKyJCGerpBchHmAvSWAa2xGHkpYwr4b/
	 3hGROIWH8dacrQ6f1LjyWDrVJ282Abav4LvIsn2rE0M9dHbgE0+UL+0uZBiX9FwjKB
	 oMdDPuJmhgHW6m8NbHBaRyBePCbnPFCqeepO/XS4wAsPQmL0T63OcZE6Q5ZaWn/S+X
	 uTBN9FKvdAcDTNbMASr+WpgrqFu6Da33TiS0cOOmJRUc9GfArmLx4HXm/ui2R3RWwp
	 yzJYU8tTtQNnA==
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 10/16] fs/buffer: Remove fs-layer decryption code
From: Christian Brauner <brauner@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
 Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
 Baokun Li <libaokun@linux.alibaba.com>, Jan Kara <jack@suse.cz>, 
 Ojaswin Mujoo <ojaswin@linux.ibm.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
In-Reply-To: <20260624050334.124606-11-ebiggers@kernel.org>
References: <20260624050334.124606-1-ebiggers@kernel.org>
 <20260624050334.124606-11-ebiggers@kernel.org>
Date: Thu, 25 Jun 2026 09:01:34 +0200
Message-Id: <20260625-kniefall-gemauert-strategisch-f4ad784de60d@brauner>
X-Mailer: b4 0.16-dev-d9d01
X-Developer-Signature: v=1; a=openpgp-sha256; l=381; i=brauner@kernel.org;
 h=from:subject:message-id; bh=o7y3zrWWLolQ8rjHQUEvtkfJrU1SIgeSJi1z7iC+nrk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTZXArIvNXXXfhZxvBow6k26TVNu3SOVMs/nWLSIni5J
 mSRaMXajlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIn8CGT4ZzTD+2Fi1YtLfesm
 c3BFrgviP92eJvfK9aaOhcbLOkl3Fob/rhOf+5125WLY2tO6Q+q5pbTe9sLkpgtL/h5U6f9/paC
 OBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Action: no action
X-Spamd-Result: default: False [0.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:ebiggers@kernel.org,m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[brauner@kernel.org,linux-fscrypt@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-1678-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brauner@kernel.org,linux-fscrypt@vger.kernel.org];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D89DA6C336B

On 2026-06-23 22:03 -0700, Eric Biggers wrote:
> Now that fscrypt's file contents en/decryption is always implemented
> using blk-crypto when the filesystem is block-based, the fs-layer
> decryption code in fs/buffer.c is unused code.  Remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>


