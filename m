Return-Path: <linux-fscrypt+bounces-1545-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHGPD4yM3Wn5fQkAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1545-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 02:38:36 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E153F494D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 02:38:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DE5B430164EF
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Apr 2026 00:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2EE1F8AC5;
	Tue, 14 Apr 2026 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udqUjDCn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DFE1AA7A6;
	Tue, 14 Apr 2026 00:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776127107; cv=none; b=T/sEhUKkCXBYKk0aN6M+hJgCXI3041bBkOa0aYjiM6Lq1hGk0shLOTkNQvKw1FTJ0Xsx0UOuuw5m3htUn+/2bu9ZylnJ7YnB9PigNspBi3gQCPqRZS4PK0Z5aTCoQxeCn3E54ivboFMsAbPDthyzcSXgNLJmywbdtMPTX1J8J8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776127107; c=relaxed/simple;
	bh=vquBGZDDcr8I+SrjnwzXt0aC2jgbidZkGZbvCyRf4qA=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=FffKRK8+HtM76oAWRpLA8Ab7HAqAQA1OtGWEzxKrXjFvbwM5NT63vtkHxW5B/La94ZsKvrcAYFZKvfd03wNoziVwhAir8LMWLt2bFWdjCnM/QqxBRsZ/usfDnV8ZAD26sfv6weEgkDaH7P6FEuA02H7fCn/fU35jzGAOBlaQgxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udqUjDCn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D29DC2BCAF;
	Tue, 14 Apr 2026 00:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776127107;
	bh=vquBGZDDcr8I+SrjnwzXt0aC2jgbidZkGZbvCyRf4qA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=udqUjDCn+brac9KkQOkdLq8i11o9y9VubW2FrefzlUql9YAE7RJ7fKVX4P1b7cN3n
	 ZZCZ62Dafiy5CJNf8tKibPenX2egRcv+2NDNv3+IlW+zXKbinUqscpIujxbxXr0cM+
	 7XOK+kbqizjLxAwRnqiQoqbpJp4LXxt/+1Oh6Qx3to7X5TIUkEaUXwLGCkoUaVcXE7
	 Ch7A/JseNF9qpzPOeZojvbsgS6GU2f/X+CJAqhOoI5U9CW+mfOS/pHWH+wJNsVLMrf
	 Y/I68HnQqVPtGhRfVTcHOfTwVdhv3H00dKZpRbHgRggqwpwwYmJCLIKkSgw8oUHAMr
	 8kdlrtwgCnxFA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9DAF3809A0B;
	Tue, 14 Apr 2026 00:37:59 +0000 (UTC)
Subject: Re: [GIT PULL] fscrypt updates for 7.1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260412001820.GA6632@sol>
References: <20260412001820.GA6632@sol>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260412001820.GA6632@sol>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus
X-PR-Tracked-Commit-Id: 1546d3feb5e533fbee6710bd51b2847b2ec23623
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9932f00bf40d281151de5694bc0f097cb9b5616c
Message-Id: <177612707834.625472.17166940906300633902.pr-tracker-bot@kernel.org>
Date: Tue, 14 Apr 2026 00:37:58 +0000
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1545-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pr-tracker-bot@kernel.org,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D1E153F494D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The pull request you sent on Sat, 11 Apr 2026 17:18:20 -0700:

> https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9932f00bf40d281151de5694bc0f097cb9b5616c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

