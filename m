Return-Path: <linux-fscrypt+bounces-877-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 533CDC1337B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 28 Oct 2025 07:58:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 500C11A6520B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 28 Oct 2025 06:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C425B27144A;
	Tue, 28 Oct 2025 06:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="jWJDhr5q"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A4A2571B0
	for <linux-fscrypt@vger.kernel.org>; Tue, 28 Oct 2025 06:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761634728; cv=none; b=UlbSCot1+1LhEO95prSTk1RgsCuPbgZiOAAlOv5FClZ6Nvq5O+I3zAyiyR3viB9MveJUaJxjjbDvXNLqH1AXypMOq9e1dulOeX6/HKbaqXFkcz8SBfIAPzzbTSnvHAJGqj/rwyU75VmGGDGWZA99FvRmrNHYIIClXwBmA3yGuAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761634728; c=relaxed/simple;
	bh=IcpcehS5Fl0yImjYpIaQdsh2MtDqwKJCpu0+KpAln1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h+OjZiW7JRfQFqn5nmv57a7nLh27w+81+BWiLzu2YktF6+236FMaVL/nJy1yoUDGXFKeTPBv1Z2XwbItAlfPeCJSggzHW62xogScg0ZnXD4pRSIIqRaCnmDvUa43zf845qIiqD4P4ccBWbks0mAG0JTfBFD9fOswmGZnD27eyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=jWJDhr5q; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso4650057a12.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 27 Oct 2025 23:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1761634725; x=1762239525; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fQ7p6xtC28C9VulZxo2oktqaX1uTl7IBrRCBfSYBTAg=;
        b=jWJDhr5q0gPLs8HF7sgH5yMPPez5imPdJ3wQh/rtFZqynn2bwF+jn1byZtbWUdPAG5
         78uOzYB3eFWxTDq/k7JqZHROoAXTuUymUGMbjGF2g81DBXTjIi+JW/NBOBWzmNC4fMXA
         HhbfuMhZhBeWeHgApSthiGUuVRnQ40uk/Wuv4OF3g0ze2xVY3/+DyBO/HtaitwrEZUm5
         Thx8o6ekIMc66EIWfwUjq7R+a6jC3fkYjDWq/civHTzoGCt7Iu+D7G6Gzx4YICIBUBgp
         AxDfQpJe7eT8w1SN+dRdpzPvdZEgcw1mMsChvLNV0JsYBfqwePtMfAVWnAlUftgbbmZF
         GD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761634725; x=1762239525;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fQ7p6xtC28C9VulZxo2oktqaX1uTl7IBrRCBfSYBTAg=;
        b=rjJaCIt0KxwzsjmgZ1SD7DOIDQSXeNFaFbcIOMSvf+k6Js/l9vbEKD1F378LSnuAR2
         p9+bnnObNnL5INd+hc1967OVpuTlEF+ILV6wlHqvNBE8D+8xJ3eUgFyxeAxJD3U/wq3V
         0B60P7igpxRvecY1uPVI8vmILVpDrbz9kT1B353q/rQikVB9M8b3p7JX1Y9jqjtIlhWv
         h3RZ/wihOsLRg1/tZ5XTo7JWsXT0kn4MKllCXuONYOoySdlWpGYgRM5+ORptFdLomACc
         lr7Ak3IfD1Qny5HEcYsdfft161T0MHiPP4IcFpNWISN0u1L2LUcKGsW+4dNqVKlrtq+u
         neNA==
X-Forwarded-Encrypted: i=1; AJvYcCWuS6Z4RgX31pgX+Oqa9OlhxaesEHAONmTiUCyG8vgDRLn3irCVQ+Ok1rwj1HVQfQuJv8euOhcXcn6XZdTZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwtVbJ3Cci2aJsClGZo0go5eH0NCzR/uVUIGwtrzOk0EFZq0jKY
	+DkuZ7uMlRGz0UvF3yrf3KdzwtsBzT4aBC1qociVE42fQkTWSMtNzZ7cpq+tblPukfc=
X-Gm-Gg: ASbGncsAWrmwHvcoMKbhEfY+7O/a3wJwPEDVygRuj1hJhYO+VtVes1I9ETQFvQFu8WH
	Wb7Fb/TCWoU6pUPQ2uq65VAp66NMsiYzGWjD7yQ5RuuWHm4fWOT+QNzqBD8Xl0Qjy/fIHG6fHef
	QZ/k1bQtnYio+WLPEcWGdu+wGyTY7dfc2Yjas6XcKrvECxFU/fvaOd53ln114eWHHRwUzVQnN4R
	jzlc1o1hdhCPlS/VxiAcpJEzlhLgcMtRA+1jwmAn3frNkO5UI/4U1Yynr57EU1u08Y2AlRYCCof
	kyE+2JZftBvc/XdOdo4bNh7BPAxUTuuIBvxMYFfgODiICjUMY7BEJWd32/eMBXqqoPReTOVJ+y5
	CezVvQZY2dXHbGnB47do8LD5LssDtMKDKmIQgWoihs7O4nAB26xqHKWYNDfAJOi22oEdhULYWWd
	aNxVvACiLCtLaqF79IdXFi2w==
X-Google-Smtp-Source: AGHT+IEQUls0hQ7f0z+eHUlXVig3EP8vmtgVoNPcCaAzKcFm3wz2AgyR/G6DDFlaIKDkK5sA6SsRRQ==
X-Received: by 2002:a17:902:ea0c:b0:269:91b2:e9d6 with SMTP id d9443c01a7336-294cb5196eamr33134075ad.46.1761634725462;
        Mon, 27 Oct 2025 23:58:45 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:d6d5:e94f:6bb8:7d7f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d42558sm104262595ad.69.2025.10.27.23.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 23:58:45 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:58:40 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: David Laight <david.laight.linux@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	akpm@linux-foundation.org, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v3 2/6] lib/base64: Optimize base64_decode() with reverse
 lookup tables
Message-ID: <aQBpoI+93UZg1SqN@wu-Pro-E500-G6-WS720T>
References: <20251005181803.0ba6aee4@pumpkin>
 <aOTPMGQbUBfgdX4u@wu-Pro-E500-G6-WS720T>
 <CADUfDZp6TA_S72+JDJRmObJgmovPgit=-Zf+-oC+r0wUsyg9Jg@mail.gmail.com>
 <20251007192327.57f00588@pumpkin>
 <aOeprat4/97oSWE0@wu-Pro-E500-G6-WS720T>
 <20251010105138.0356ad75@pumpkin>
 <aOzLQ2KSqGn1eYrm@wu-Pro-E500-G6-WS720T>
 <20251014091420.173dfc9c@pumpkin>
 <aP9voK9lE/MlanGl@wu-Pro-E500-G6-WS720T>
 <20251027141802.61dbfbb2@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251027141802.61dbfbb2@pumpkin>

On Mon, Oct 27, 2025 at 02:18:02PM +0000, David Laight wrote:
> On Mon, 27 Oct 2025 21:12:00 +0800
> Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> ...
> > Hi David,
> > 
> > I noticed your suggested approach:
> > val_24 = t[b[0]] | t[b[1]] << 6 | t[b[2]] << 12 | t[b[3]] << 18;
> > Per the C11 draft, this can lead to undefined behavior.
> > "If E1 has a signed type and nonnegative value, and E1 × 2^E2 is
> > representable in the result type, then that is the resulting value;
> > otherwise, the behavior is undefined."
> > Therefore, left-shifting a negative signed value is undefined behavior.
> 
> Don't worry about that, there are all sorts of places in the kernel
> where shifts of negative values are technically undefined.
> 
> They are undefined because you get different values for 1's compliment
> and 'sign overpunch' signed integers.
> Even for 2's compliment C doesn't require a 'sign bit replicating'
> right shift.
> (And I suspect both gcc and clang only support 2's compliment.)
> 
> I don't think even clang is stupid enough to silently not emit any
> instructions for shifts of negative values.
> It is another place where it should be 'implementation defined' rather
> than 'undefined' behaviour.
>

Hi David,

Thanks for your explanation. I'll proceed with the modification according
to your original suggestion.

Best regards,
Guan-Chun

> > Perhaps we could change the code as shown below. What do you think?
> 
> If you are really worried, change the '<< n' to '* (1 << n)' which
> obfuscates the code.
> The compiler will convert it straight back to a simple shift.
> 
> I bet that if you look hard enough even 'a | b' is undefined if
> either is negative.
> 
> 	David
> 
> 
> 
> 	David

