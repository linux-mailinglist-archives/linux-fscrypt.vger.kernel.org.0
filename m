Return-Path: <linux-fscrypt+bounces-1557-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YIUYJewx9Gnv/AEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1557-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 01 May 2026 06:54:04 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7B04AA696
	for <lists+linux-fscrypt@lfdr.de>; Fri, 01 May 2026 06:54:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 93E82301AD03
	for <lists+linux-fscrypt@lfdr.de>; Fri,  1 May 2026 04:53:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641DB3033CB;
	Fri,  1 May 2026 04:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwcKVh5v"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF2E2FFF8F;
	Fri,  1 May 2026 04:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777611225; cv=none; b=DPY187eT5I9p/TYkjwfCrudtFBJjHRBQahQMjsAkkjEgogJ8LJxk4AokA3rpa5Ae/Ju11gVv/rpFMzA0yiBEpBaTUC1jw+g3HpuxHoxMaMsEnoZk6L9R4ak7P3oHYTW5ESwL0rIJ8+av6zQ5zbAjS04ZyzfRpbcTHlJbrHLqO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777611225; c=relaxed/simple;
	bh=MbuJTASI1NMr0qwmJMQcwY2ZaenMiX6xo6i5oAcLOmw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Dzkf3JvIbqa3K/7IiUBCTLFGhhy3OozX7OQ7NVwmPvGZp2Ri08pibC65M3IJMSWfq6uTm8YhDEhwSkX0HntHdOTpLLmwKgniOQOaeJXJri7QHfrv1ZKQi+0mA8E+sAaH2GM0wZ6wJ4fTaHV2OhYSiNrIszLIRURgHTuh0BclcsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwcKVh5v; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A0C2BCB7;
	Fri,  1 May 2026 04:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777611224;
	bh=MbuJTASI1NMr0qwmJMQcwY2ZaenMiX6xo6i5oAcLOmw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RwcKVh5vkhuhNmPt+56eQe4YaRxH157iDCwIBQI44xZDpVko4cO8Lnh+jzL2OTIVN
	 1kvrCbC9YKaV7bJQKRa/gIBMrUHE2Pjcx3R+N2fWKS2S1Gzewv0lZQV8/7V1HaNBJ1
	 45cR2EsE052/mQri2rt1egREHRNWUn/ePhMvlHL7YyAnY307T4vCvMOMDrnglhVZOd
	 8DvnAPRMxapteG6OONcB6VXaN3GXethlHSK8k7+xsauI2wW9tHrYyQ0PZsXWwhve3l
	 39lJblOtvun7IlcTO9+VCT+rHIwoL+JuimtkF8Ro5ZUR3G+2AsOoZcInpKcBjdxBYq
	 hyJ0WfM5QkPcg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 09CD2380AA67;
	Fri,  1 May 2026 04:53:00 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [f2fs-dev] [GIT PULL] fscrypt updates for 6.7
From: patchwork-bot+f2fs@kernel.org
Message-Id: 
 <177761117874.3324081.12076569941435908568.git-patchwork-notify@kernel.org>
Date: Fri, 01 May 2026 04:52:58 +0000
References: <20231030040419.GA43439@sol.localdomain>
In-Reply-To: <20231030040419.GA43439@sol.localdomain>
To: Eric Biggers <ebiggers@kernel.org>
Cc: torvalds@linux-foundation.org, tytso@mit.edu,
 linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 jaegeuk@kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
X-Rspamd-Queue-Id: ED7B04AA696
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TAGGED_FROM(0.00)[bounces-1557-lists,linux-fscrypt=lfdr.de,f2fs];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[patchwork-bot@kernel.org,linux-fscrypt@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Hello:

This pull request was applied to jaegeuk/f2fs.git (dev)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Sun, 29 Oct 2023 21:04:19 -0700 you wrote:
> The following changes since commit 6465e260f48790807eef06b583b38ca9789b6072:
> 
>   Linux 6.6-rc3 (2023-09-24 14:31:13 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/fs/fscrypt/linux.git tags/fscrypt-for-linus
> 
> [...]

Here is the summary with links:
  - [f2fs-dev,GIT,PULL] fscrypt updates for 6.7
    https://git.kernel.org/jaegeuk/f2fs/c/9932f00bf40d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



