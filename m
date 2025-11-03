Return-Path: <linux-fscrypt+bounces-901-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0181AC2B410
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 12:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 03D871895279
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 11:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3F8A30148B;
	Mon,  3 Nov 2025 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3UfXCBT"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F642F90D5
	for <linux-fscrypt@vger.kernel.org>; Mon,  3 Nov 2025 11:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762168052; cv=none; b=Y3quuRtN3WNEWqxWmcJWkSLqWOmT9ur7lCVCpbI7L9cypCZDse3eD2fgM54BTw8kXAIlHfJJnL/fORarHTHfONH44avuvysuumFY6RoUXVUVb0j8KJZ+vRiCffFcNk/v41q55OdeRGZz8y40X/Om0MMRtDZ9Hks2ZOgbEKeh8M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762168052; c=relaxed/simple;
	bh=mA9KY7uIbnEgVR1SSsuX7u/ye9v5ngsAxc98lcuXZH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNfovDh9qUdaZeQxVk25IPhAvkWQRSbkOKX63bUptKTWPadQ8kmUZPJWS3f/E9F2hrWxqRWn60KSLRgFko7znvCbtqyIlfp9rXw6/5P0DzlHVd41C2kEqG7lN78fFK0PIuxy6/XTuw3I9/ZrrfQQlKohd0ewc9N4fnNtqm3SC1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3UfXCBT; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-34101107cc8so1059553a91.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 03 Nov 2025 03:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762168050; x=1762772850; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vd+5KBI+DcPHKtaahVWDgGYJD9ObtH7hyDt+uX2+Cpo=;
        b=O3UfXCBTarRt8XRvzh0S/4L1Y/dWHF1ZHDWIHX8SM33zfclszl7OUDhBtlIeihohf/
         hVOOnVcEC1VwBGjRyLOuU7m+rdVEamTTVxZxXx8sSw7mmqTQ80QlynmOozD65EovddkK
         fu1vkzrhGvzdLhBQFx+WSXE0md678a5lSCFKyCblshPVupCBVp90sBy6CQ96OwjPkjLR
         rhsvgLuS8lWbAqLoNvZprMWHomoWhp0L2Zs2bkqTVOuscTCzlCN6Ef1tK/idiBRSln96
         XsxEEtoTa/Ls2S6OWhADBVRUeOdIvopTAmoFkv110Krpshr9syxCgNFdk9SGj3weT8G7
         Oa3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762168050; x=1762772850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vd+5KBI+DcPHKtaahVWDgGYJD9ObtH7hyDt+uX2+Cpo=;
        b=B+dRS9c1BhZ0RWSUHea3c48ce7bNvpHqup3uTkdhTU5ipwTfm9GyxInwCzrGXixZvO
         /dIVUYlTwuChm+AanUBq6y4PkgtM6QAiUDpwO3Q1DjO+vsy9Dzo5OGnl382Q8u1ItyPU
         kcArQwMvFPx43V+AL7Pj2E897K0zNmKzQdhtCxLD6w/oW5UShOiWtleYSMPVRnvSpyNn
         JxsS/1mJQDiW7X9YWMiZo4BQAAg4j1yGjBJmXZxCU+O33GgUlxgJUOEYG3ycShW2tfo/
         aFiteaq7NTu4EN8TzGmNT6TretrO1GwBRMM7ugJtDpIXKqUPRpXa36ZQslr3+U0tiNql
         2rGg==
X-Forwarded-Encrypted: i=1; AJvYcCUSPcPMItvSOt5JgPIcNoKyL69SRxte+b2fnmapct1Z7a43LsKZLyxYxfzRUuym2uTE5KG707wYqS0J1gqX@vger.kernel.org
X-Gm-Message-State: AOJu0YxWbHPDn5Z9tGuA854HzizZtuFX7sb06zkYtF/HF3qHTZKZQPjr
	CI+gzHlqn2/BYKZs5wy3OQ3zqP+5L35JmuO/daHeCgDrgGJzb0a/s+MoIVrLxv9l
X-Gm-Gg: ASbGnctUX5Lo0wLx/E5oWKNxLUocj/1H11xTt834KVUZVoULPD+ZbvjMB/oyJULstVr
	7Frz1b9lScTPxFpu84rbhbZ7zA0o5j48ASUAG60y54/sQjihZxRy6Y02igPYf4TJ+KyBLn6kwQ9
	854V/D3q4g0FUE+mJPUdspyOSwb2xW26/87BLLGFoelrUAPkQelhl9LMuWgOzFjdPsYc5OTZ7t9
	PNa/nbZKqw2IZQMeZI7ceL+WkglGsiO9d8pnTnY/aIFn9X0yHhZIC9zKvM89oS7NYg0XP1ZXTcN
	7ujzKCkBmU+wKzP10VxmH/ZH2dkyHhEspO/aGOeL7klBPvLkOpFXX40NB8cTMiFx+kwlwNK/q4N
	cYvPkCOFO43oJQ7KN9t1ygpCOSTLSfNE+4cAqd1EP993A5MNoMEEX6e5Aj2gJmg7ZwibJEPt7EV
	4++eREVOudIAnj+UwAPvlU29Lrqxp7GlIeg1jnmQDie9ZMTInHXgi+/udQNAfXfDKXX2U=
X-Google-Smtp-Source: AGHT+IH4+9frysi9DNFV/2/WAly7wk4mYQWIlTpjWZue0G81QDWwZ4rfIb4hTAprNc33o6VQINfi4w==
X-Received: by 2002:a17:90b:314e:b0:340:d511:e15f with SMTP id 98e67ed59e1d1-340d511e56fmr7617741a91.18.1762168050210;
        Mon, 03 Nov 2025 03:07:30 -0800 (PST)
Received: from google.com (114-39-189-33.dynamic-ip.hinet.net. [114.39.189.33])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b93bf44e233sm10126135a12.34.2025.11.03.03.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 03:07:29 -0800 (PST)
Date: Mon, 3 Nov 2025 19:07:24 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@intel.com>,
	David Laight <david.laight.linux@gmail.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aQiM7OWWM0dXTT0J@google.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQiC4zrtXobieAUm@black.igk.intel.com>

+Cc David

Hi Guan-Chun,

If we need to respin this series, please Cc David when sending the next
version.

On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
> On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:
> > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> > 
> > > This series introduces a generic Base64 encoder/decoder to the kernel
> > > library, eliminating duplicated implementations and delivering significant
> > > performance improvements.
> > > 
> > > The Base64 API has been extended to support multiple variants (Standard,
> > > URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
> > > a variant parameter and an option to control padding. As part of this
> > > series, users are migrated to the new interface while preserving their
> > > specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
> > > and NVMe is updated to BASE64_STD.
> > > 
> > > On the encoder side, the implementation processes input in 3-byte blocks,
> > > mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
> > > streaming and reduces loop overhead, achieving about a 2.7x speedup compared
> > > to previous implementations.
> > > 
> > > On the decoder side, replace strchr() lookups with per-variant reverse tables
> > > and process input in 4-character groups. Each group is mapped to numeric values
> > > and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
> > > rejecting invalid '=' usage and enforcing tail rules.
> > 
> > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > for this code.
> > 
> > > This improves throughput by ~43-52x.
> > 
> > Well that isn't a thing we see every day.
> 
> I agree with the judgement, the problem is that this broke drastically a build:
> 
> lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
>    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
>    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
>       |                  ^
> lib/base64.c:35:17: note: previous initialization is here
>    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
>       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
>    25 |         [0 ... 255] = -1, \
>       |                       ^~
> ...
> fatal error: too many errors emitted, stopping now [-ferror-limit=]
> 20 errors generated.
> 
Since I didn't notice this build failure, I guess this happens during a
W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
to my checklist before sending patches in the future. I also got an
email from the kernel test robot with a duplicate initialization
warning from the sparse tool [1], pointing to the same code.

This implementation was based on David's previous suggestion [2] to
first default all entries to -1 and then set the values for the 64
character entries. This was to avoid expanding the large 256 * 3 table
and improve code readability.

Hi David,

Since I believe many people test and care about W=1 builds, I think we
need to find another way to avoid this warning? Perhaps we could
consider what you suggested:

#define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
	[ 0 ... '+'-1 ] = -1, \
	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
	[ '9'+1 ... 'A'-1 ] = -1, \
	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
	[ 'Z'+1 ... '_'-1 ] = -1, \
	[ '_' ] = val_under, \
	[ '_'+1 ... 'a'-1 ] = -1, \
	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
	[ 'z'+1 ... 255 ] = -1 \
}

Or should we just expand the 256 * 3 table as it was before?

[1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
[2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/

Regards,
Kuan-Wei

