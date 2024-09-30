Return-Path: <linux-fscrypt+bounces-481-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7992898A8DB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Sep 2024 17:41:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69B95280E0E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Sep 2024 15:41:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B977F194080;
	Mon, 30 Sep 2024 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="csafDKve"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A1F19342F
	for <linux-fscrypt@vger.kernel.org>; Mon, 30 Sep 2024 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727710851; cv=none; b=HSPxvzT7NCc0DUMDrvc6tN0s784pthF/6vQzv1xLwkLQ2jzwOzUcf3OIrshqn9kIKGlE3IQWSh9DfCFK+mW57IFukMjbwfLGg9GXD+3ueKu4DotgW3XbHOJP5z4iGNBQBR+6aFXzZTgafomxNtUcarnmocFRBhihlZrmVdd0U80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727710851; c=relaxed/simple;
	bh=fDFumAK9igYZ+CxTHR9gCbxjlAoTzynxL/GKvBjAzsU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M3CXBrU8CjemVAHgpSVHDaFaAH9EprMGOxXwvrT1etPVJYYr0qKhuNPaVN9CQLclCq7vCez8dpMIK6uKq7emS17MKbarp4Il2q9c+c4P15MGSl2VKIoaItZitAzGw8xFstUYkbqbjJ64MmOsmCY7k9GoXyEFzp6pipY4/LeWJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=csafDKve; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20b1335e4e4so41459015ad.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 30 Sep 2024 08:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1727710848; x=1728315648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gk4IT+ziW7GSilMgu7AJgpoE41t4jq/Ls2rSzqW+beE=;
        b=csafDKvefF/P8ZewMQZITH2n/3TirhLRyV+fyujN8sG/8QTfABFbl7uLHCVd3xJp8o
         i45ZC5vAhS3FncRjCQg9sznJVAa/MzMr+8+NRoWXbcd3zT6QOVULcrStd3Rl3Rakgnsb
         lbNgj9YssLf7SKWOxuz2exxKwC/990ZbmOz7KpSNQDosnOPDfjtqUuWKcJYsZg2LTTH8
         2a9MHrQfG8BLSbJ0nm83tK11XHl2SLd4vXbn/KTk5e7XmrRwT9aAPk+0f2JqFSk7n6P6
         WpmPzQdRktvTnOG8m+pn3jDkfSE3OlgQgBJhnuzuJEwjNcTj9E0Hgmm9AnfaxRJVU1Kl
         7zYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727710848; x=1728315648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gk4IT+ziW7GSilMgu7AJgpoE41t4jq/Ls2rSzqW+beE=;
        b=oqGQrSSMU/I30n5TqaNMyCSAAEIoeuxc4V//yVJDMBBb6zGAO3waf1sFhHaszXT15u
         a6fds0TmX/ZcIiyqE21hXQWIxX37zvMWCAuQewLJ5syxR5AJ/TuinjDDvEceqru60oNX
         lIL/AJsqnBho7XXLWNkjZ4g9UEoajoXDzbO3N9rH5SNlNazsEcK9SRwOsCOPIOVhzrHJ
         Qum20mMd62BSdyhMedfHFBdqW3etIYLjijnRzOP8fiMbGv+TxMnzG8bxbIs0V3Pa/MnK
         LFgNBgJL6dsLLQ+MgTZkbOZkKheVOGsGnWegRuHioReCGR/Di3bc5nrsIoUnycg5gKCv
         I0Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUBSspOWLt/UI1qnrWhU380JX63bletr3uOvZKhOQMUvymInDaxaB1MwTWHVnf3ytd5KItHqahXKtTqhqn/@vger.kernel.org
X-Gm-Message-State: AOJu0YwDNDc32MrPS+CSC44cphc+hsl1RZD/gVkhkoHZJvGwMvV5WdN7
	0InSNvh5p/VBRFmRbmGF8Q+vU9jdLrRzIkZJbUonR0NByE3EYiwHnBAbTS/PNS4=
X-Google-Smtp-Source: AGHT+IEBTYKGJiVF/hvLtnqHSF6GUD7YmyDMyv0oyolLcyv9IFVLXr8V4Z3pE6cLuKRIJT4zroumAw==
X-Received: by 2002:a17:902:f54f:b0:20b:5c94:da02 with SMTP id d9443c01a7336-20b5c94de48mr112201815ad.33.1727710848215;
        Mon, 30 Sep 2024 08:40:48 -0700 (PDT)
Received: from hermes.local (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e6c997sm55788515ad.307.2024.09.30.08.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 08:40:47 -0700 (PDT)
Date: Mon, 30 Sep 2024 08:40:45 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, linux-scsi@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, Jamal Hadi Salim
 <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>
Subject: Re: [PATCH v3 17/19] netem: Include <linux/prandom.h> in
 sch_netem.c
Message-ID: <20240930084045.7c0e913e@hermes.local>
In-Reply-To: <20240930123702.803617-18-ubizjak@gmail.com>
References: <20240930123702.803617-1-ubizjak@gmail.com>
	<20240930123702.803617-18-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Sep 2024 14:33:28 +0200
Uros Bizjak <ubizjak@gmail.com> wrote:

> Include <linux/prandom.h> header to allow the removal of legacy
> inclusion of <linux/prandom.h> from <linux/random.h>.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Makes sense

Acked-by: Stephen Hemminger <stephen@networkplumber.org>

