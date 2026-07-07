Return-Path: <linux-fscrypt+bounces-1749-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id G8dNCBsSTWpXugEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1749-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 16:50:03 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B88A71CD6A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 16:50:02 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=google header.b=ev2D1lNt;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1749-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1749-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0D4FB3041CFE
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jul 2026 14:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCF1342A142;
	Tue,  7 Jul 2026 14:33:27 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6868C429825
	for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2026 14:33:26 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783434807; cv=pass; b=pC1rkHkkv2Gz3pAJEen+5FcuV8WZUhK+3uQQZXca/SWV2qkTkENbxYk88nUiG+PmKuf0u7fFJ1t74xL72lSKXQwaswQEYOkvMS5lddgMJwF/Irsu3d4TKk6TrJBM7iS5srjaoky4lkPX6v15Vy4WrHnvTGEl+ihUYyQyxhMPxf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783434807; c=relaxed/simple;
	bh=xYilDSxOI6do0n6SZKC31MPiyy1EBx+XTChNkNJ4Ayo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YlslIkgKSbT1WS0jvQUrnPAPx9BAlFbA/rzY6YMjQW8ms2tuM9s+gMc+n4M5SW7B6cF0e+KJ1V1sjKTCxaWklIZlJcbE2OGUpPFJ3cV2BCEZvqluxKoUG9UAoL537s/mQiKwP3G6ESZA+VMQhiA2aFl8t3zzAdrg5nBAgNpj8fk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ev2D1lNt; arc=pass smtp.client-ip=209.85.221.44
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso4313004f8f.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Jul 2026 07:33:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783434805; cv=none;
        d=google.com; s=arc-20260327;
        b=gymvlnI+YifX8yuzdnd/MIaCLZofQW7xa8rcpV76FI3WjjuMstvtxCLOqsD8jT3KyN
         4ZtaQgDZ+05x/Ohs55IOn68abx5XvVfYem3mSckWq/wD6vQNu7HUboht4q4KafTdvmDa
         9a01BlyuyQQINDyXoqz02FiyZiow73iSV40lObH2vTV8KXRNc9L+c7to8uMOWcw5oCeH
         QWTyvZZEpRHvLYFKlN72kZACK+XtWoBc3XNC5RjKzh2oRPZbgzpnJRR5u2URmkb4lMPP
         vG7XDza94bamhFoBzlDuEU//QXfmqitL70nfkb7GLlNb6aY5ZU5et5rPFnfOJJVTdKXP
         RpsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        fh=KLbe2zx9auqhDFkoTsO0zUv8kuyZHDUGT/blhMlgLyA=;
        b=Df4B4i0C6Nt8Bn0AewRH7chUkgWCgmnO9vmyfWgIWC7AnhMk3DM7GSBNuJSMmKmDPO
         DJK2Lv6tYtIPHTO9XlEF648X9gSSq5GWNn3tVfPQNsytaUwjVBKEx6C4DR5oEZTq3t1H
         fSkDuh23Cgwx2UiiNDexzaG9kkegkGD0jxRRFzsJeGAEcGD8swoA+STJkLmYj5WxtP90
         CFai9UZhSfELD8fkyVvxWgafAcpUaT7t7uwDeGGhBOyD3Fo6NlD3IVhybeY2I89QwUV2
         3VyrqZzXCx1Ls3SvJb0RvkEkGDKXGTxCsZwEPRFrxjBKiEiKC0S5v7aTKqVzVsvi2O76
         fa0g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783434805; x=1784039605; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        b=ev2D1lNtzENVIvhWHnFT6xVDI8kWjyWmpShcqxe96CSgaDwc0KJWgDIODfIj7opaUZ
         KtwcH43HlS3L3qituEtpIcDQv9XlK7KlLBi2UhRZbzPEURWXJsQgycWpFoiOK/oZDNlH
         hbGNJ3hi/ebdsgfN4SihRkq2bLHKT+s8BgLb7lo3kG/qqsAablZF9vYZHJ7np2dUkdtU
         WDvDxB+h+6p0K7NG4Tr2K5UdJHRPc5wMkjLmWY6eALA4j4QGVHWJ7Fa95wAudt5gPxvI
         QMiY9lFfiME2wgjCliXtPD0GE4hLIEm+9iLxyESHMlA4/t5BOKVmss1kYlBZpSBTpEV5
         jkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783434805; x=1784039605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NEyRUcC0eInL1m14heAugAgai/7ecjcR50dungH3ju4=;
        b=diRWjDcFqXI3+KgR+kvl1XZnvUI6JROVjgSJ8yEpPiwsb+66giqxu0PzXHLOr286JV
         kZzlKkd3HqTORldGmM8hrpu10Qx4FYBQSyX7t3r6aZWJjJVF9gQ1jFTuVeQqrtlQNgeu
         q4VDkgYNY6MaTyp9Ht3RIm0DMfL0CHVgxALQ2hmHlsVTLIR+xcOfi1tHMUlFa/uLvjqR
         XJ8qswrAe0wyaqy4rVIa7Ur3utQNDY8UEuemNX+L9kTB8EIekb1enTTHaRQpsV4h4RVu
         cI+T+FO7CReMuDl+sB9VuKHREnldHGDEDujH9ZsOx45LZWseVQrZ3R9rlsnPvCaWuf40
         cTvA==
X-Gm-Message-State: AOJu0YyZBs+xE0qFLu+KZXfoHVUf7lQav44Bw46AZ/GPXd/Si065IVTo
	JuO23BM2a16AsZvrRnDv/CxXODoPB/WKERF4/HFL7TKZPjrWoFilqNps0kj5NZGpIMD/M4FofbW
	Ri1T/QUj0blywcHItz+1lJP3WKLJgkv1EY3EClC7a3Q==
X-Gm-Gg: AfdE7ckEEu2KL5I1728+ewuo19bvc5qqs5yEWOcdckgdKIm9kzHUbUm3mtXy+meXtkx
	6yUfU1PvyDNiTqsZRbdvg6rvGNva/zAEI093YHhfTWK0xIc8SKbOxDgOB1Ag7Az2V57VcvzIJLG
	QX2imY7O30jBXfKyVAIHXT/1vgCSl1SBsLkiikX5UIis+iQPrGQNujezEEfdZMOyOfca4yYtnTK
	bJQXTOPy5yHTKmdjqsp9uyItq8cBVwd7wyx3NrqKct+kymLoRt4pHkJdmgtSX6pIFtRbwIoL4gG
	7d7amd0zi3OB7PWW2/rpHIiudFMtzq4Fcy2fwm29b9959Aw1wUM7JXF2eDlCifoKohcPBQ==
X-Received: by 2002:adf:e5cb:0:b0:46c:cffc:7638 with SMTP id
 ffacd0b85a97d-47de66cde20mr4676602f8f.30.1783434804628; Tue, 07 Jul 2026
 07:33:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707142736.2330146-1-neelx@suse.com>
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
From: Daniel Vacek <neelx@suse.com>
Date: Tue, 7 Jul 2026 16:33:13 +0200
X-Gm-Features: AVVi8CeB-MDEZ61D59OuK3R240uy2Wkn9hf6StiihAh_syE3H7rsSsllB5ZZm1U
Message-ID: <CAPjX3Fcqxu_CLJzzHV7qc32+PZF=Wh2hxqfndJGOCSda2H8Z5A@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] btrfs-progs: fscrypt updates
To: David Sterba <dsterba@suse.com>, WenRuo Qu <wqu@suse.com>
Cc: linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:dsterba@suse.com,m:wqu@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-1749-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	DKIM_TRACE(0.00)[suse.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,suse.com:from_mime,suse.com:email,suse.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1B88A71CD6A

On Tue, 7 Jul 2026 at 16:27, Daniel Vacek <neelx@suse.com> wrote:
> This series is a rebase of an older set of fscrypt related changes from
> Sweet Tea Dorminy and Josef Bacik found here:
> https://github.com/josefbacik/btrfs-progs/tree/fscrypt
>
> It passed all my tests. Hopefully nothing blows. Enjoy testing.
>
> v3:
>  * dropped first patch and improved inline extent length checking
>  * correctly squashed the context key definitions into "btrfs-progs: add
>    inode encryption contexts"
>  * inline extents also show the encryption field now in tree dump

And I forgot to explicitly CC Qu as most of these changes are thanks
to his review of v2.

--nX

> v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@suse.com/
>  * works with v7 of the kernel fscrypt series
>  * the on-disk format changed and parts of the series had to be reworked
>    - particularly the encryption context is now stored as dedicated item
>      and not glued onto extent data item
>  * also parses the ENCRYPT inode item flag
>
> Daniel Vacek (1):
>   btrfs-progs: recognize ENCRYPT inode item flag
>
> Sweet Tea Dorminy (6):
>   btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
>   btrfs-progs: start tracking extent encryption context info
>   btrfs-progs: add inode encryption contexts
>   btrfs-progs: print encryptin type field of file extents
>   btrfs-progs: handle fscrypt context items
>   btrfs-progs: check: update inline extent length checking
>
>  check/main.c                    | 34 ++++++++++++++++++---------------
>  kernel-shared/ctree.h           |  1 +
>  kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
>  kernel-shared/tree-checker.c    | 17 ++++++++++-------
>  kernel-shared/uapi/btrfs.h      |  1 +
>  kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
>  libbtrfsutil/btrfs.h            |  1 +
>  7 files changed, 69 insertions(+), 24 deletions(-)
>
> --
> 2.53.0
>

