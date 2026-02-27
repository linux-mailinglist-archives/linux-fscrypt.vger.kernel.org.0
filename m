Return-Path: <linux-fscrypt+bounces-1279-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 5nA/Jwa+oWnPwAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1279-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 16:53:42 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 304D71BA586
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 16:53:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 50D4D305E9AB
	for <lists+linux-fscrypt@lfdr.de>; Fri, 27 Feb 2026 15:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAAB7441035;
	Fri, 27 Feb 2026 15:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="O7xfHkJq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3D84418C0
	for <linux-fscrypt@vger.kernel.org>; Fri, 27 Feb 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772207474; cv=pass; b=j5TXhknbydzbP4g+HF10yOMlvRk4Vfw8dKhvwH3UjSf/UHgI0z0CD5vAqgN26lgSOEZCdrNIz3zH61nwRFFolUKTOaFty0ImDjHRhyKrxAW5qtrKWKcgtKoR37koIniW6PoBK97bS9q8juUP0eENqVm+7LKvvKh/Mc9J7vGsJrA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772207474; c=relaxed/simple;
	bh=C2dXB1sxCI7Pk9wL8pHCeBM7riM5637FJHGRurs2elQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ceR9C6mH7XLqjf2Y9U1JiOdRZQ2bS1QWLaEWsKeAdWvoRqQ7PDZR9bNCWhrANm67EHA8DvqoBsv90B+ODbjQEg2uP72UlqdHOEPut+uA1xeyRlwnB42QZq7SCymOP/VH7DQTNYgcJfc8pIKBUPuPR9fFoj6lzPIRuax5/8vfrnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=O7xfHkJq; arc=pass smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so25427315e9.1
        for <linux-fscrypt@vger.kernel.org>; Fri, 27 Feb 2026 07:51:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772207469; cv=none;
        d=google.com; s=arc-20240605;
        b=K2Ph7ZmxKthpMe7okwHnCVg01x/oTIDF0+TKZ8QHUVADPB/Bvq//TRh2Geu4oYUQtG
         Biuws+LTcwBR7vaSoGnrVo4CBiDTuO7ffnD3NxIA3g6MU+nCy2kp3vEy4HZf1H+uoudf
         s8/sfLlYo42GNHwyCIgiy3JmjJyVlOqWixW+NdEzV44Oja/EaDlz64J7rYVMU/1GXhG0
         LXYQ6vkYEldbYqxxFbnTqHpGTtPOCAcRcyAWg/6kkXOK8I1/O/l27ysHeGYC+GByUl8H
         IsxgMXUiS+1bGrvBaPkfnUcT8NQbdSTJ92w0YRGTkT32k3cS85Wp1vRvTSBEt6hJ6WpT
         bVEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=rdJol8PThaHnFzgvtP9ZLYZ64xJsOVkwosdclABQFrk=;
        fh=rjnbfzfKj6E1XmfSmkGbS25/FGTs95/fZxA173gC0Ko=;
        b=Ze2tUL1RDX5OHeG2gQ3ujDfF1SDB1hYLgEKSWtdFLbPd+89W3ZsNskjCau5uZIQVZ6
         U3tEzShWrY/P7veHEHMpEKey9h9Uc2g5wfueb8wDQlovauaxFpywpWA/3MGeWiEuzBpw
         j6cmxqeUhxzgovZpfW/Pw091kiLC7ocCrFpdb+ZRworBkIiJ1EkdM5+UkLdjDsreluBq
         EGLP0BvUtBjoPL6Hyo6k7BpaO61ZKQcwpfyUs7wxTXXGQjo8Niuf256Q8XgNke8jS9M4
         pvQr9P22CCzN887AuL2JfxqbGArP6D63UQWk/ZBn9QiEbi9J5QOZ2aJCt7az18WuI8am
         zt1w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772207469; x=1772812269; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rdJol8PThaHnFzgvtP9ZLYZ64xJsOVkwosdclABQFrk=;
        b=O7xfHkJqIj7ysBjltL+OEuC7IvVKrnNE/caIfi4So4zLwms0AvlloqnR4SaSsbCDZR
         iN5wiC+rxAHlSLUT9rMACdeNPTXynI0oS3IBvZkP0iwHAB2V41FMXNtUHT5ApUcvP8OK
         9NW4oK8f3opDJUA2V9DW2OC1iQQrpgxWCky12CG5Xa1DnqU9Vcu0bW401OIN92YJpFdW
         T3FEmUHB6nB+AywKA20yuam/TrIySGBysDmP9NW0WyRY5APuYfNd96qDCGqBa8wEU55O
         h4SRqYxkRS/Wr1gxZPonSBmuR2Go40C0sztGPllflGuYHBfM/m4rB+pic5ux5krWgIYv
         cwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772207469; x=1772812269;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rdJol8PThaHnFzgvtP9ZLYZ64xJsOVkwosdclABQFrk=;
        b=uqNrwZFDOwingOwPZcPL4ir3NYrmyeSVZe424zqyCE3hQk8lqq+ysFCqFKA8TDl8u4
         9k33G+kY0tB+Aj+aFabPsGm/9pSwhtIsIUhYy93T7UXB5rLKGS69wDtPAingNEYdrNkE
         q1tr+8ujGB3P2UqWa9fTO4MDoib9vnTCCbkWPmssdnTMK4YO0SncsbIGpO8MXdm7jlCR
         E1BtabZEVPKYlnT5cC36WfdlETZ7XU8Dgt4D803+eyPK3Xll28wzkqKFoS01WOpcdk06
         HpJrAJvNZ1A0Zk0Rbas6sxL70oRjIgRIZZsDwx/Vs+gqLimY5GkHthy2Q/6GIJkjgaei
         5QNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgpQECQcfFn/aCUM1Z4JISVeOBorlqVJ/gsdxVJcekohlRPbbv7xbrdAvJql8gALESsO9O2v1tEQoV5LD/@vger.kernel.org
X-Gm-Message-State: AOJu0YxbXkmVMgcuaEm5cu2QeHw/iKfxe+wPzHzdr1/kMfcwhqFCJbpK
	oUTZUNCYvlKONy/XDVQyFn/T1L6a5bRnRxFHdUN0it4n/5BSp9Rj6t3SesODNsHpY8vH9WuGXzj
	VpaV93TSjOm0hmTFoE4tVDtlbzFO/PUxVc9eQtpUoLA==
X-Gm-Gg: ATEYQzwxV9m/4mLz3OCzvCOKnuVfKkZBdI4tGMZUZWwJZa2u09bpfqMAh1/xRT/CLSz
	s0EHZxJaDrCSslZjSzRS+VPl36wWhRUoCoK+c9jy+6WSAIJMR0BntPD+s1+3zpavIb+QfuMHs7i
	3eGiSzQs5ligdHmm2w/zvgqckVGEojkq6gRF5o/1US7q1APbXkwHK6EiD7zSxgu7kM2dojVkyCY
	GAprhoqHDwhJSt7Le+mlMLTN6jWfC4wEvvEb41IFMlbQphTOYzGp29YhttI9vDuk8mU881a2+kb
	jJ8PRyM2rUfTkcwsgm2uc/AvTGZXvoZYrrWkcYOraDRu/rj9aGiLgJl6GNqjir8l+cUVBicFH4o
	uT4CA
X-Received: by 2002:a05:600c:154b:b0:477:5af7:6fa with SMTP id
 5b1f17b1804b1-483c9c2059bmr44092495e9.32.1772207469176; Fri, 27 Feb 2026
 07:51:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206182336.1397715-1-neelx@suse.com> <20260221205606.GA23260@quark>
In-Reply-To: <20260221205606.GA23260@quark>
From: Daniel Vacek <neelx@suse.com>
Date: Fri, 27 Feb 2026 16:50:57 +0100
X-Gm-Features: AaiRm50Djn6O6G3P77GWwQPmb2f1tOFDkZh63lAskdXhiotebz4l7KeZVsyYZpU
Message-ID: <CAPjX3Fet5M2C=1TDNRhrqmanvJ2=aFdtQXfXK7MuxiOkz2rNUw@mail.gmail.com>
Subject: Re: [PATCH v6 00/43] btrfs: add fscrypt support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1279-lists,linux-fscrypt=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 304D71BA586
X-Rspamd-Action: no action

On Sat, 21 Feb 2026 at 21:56, Eric Biggers <ebiggers@kernel.org> wrote:
> On Fri, Feb 06, 2026 at 07:22:32PM +0100, Daniel Vacek wrote:
> > Hello,
> >
> > These are the remaining parts from former series [1] from Omar, Sweet Tea
> > and Josef.  Some bits of it were split into the separate set [2] before.
> >
> > Notably, at this stage encryption is not supported with RAID5/6 setup
> > and send is also isabled for now.
>
> Where does this series apply to?  There's no base-commit or git tree,
> and it doesn't apply to mainline or btrfs/for-next.

Hi Eric,

My apologies, I did not explicitly mention the base. I'll do it next time.
This was based on for-next @20260127 (commit 80dbfe6512d9c).
Since then, some changes occurred that will require additional
touches. No wonder it does not apply anymore.

Daniel

> - Eric

