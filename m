Return-Path: <linux-fscrypt+bounces-442-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 061A0971A44
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Sep 2024 15:03:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3018E1C221BB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 Sep 2024 13:03:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2455E1B9B29;
	Mon,  9 Sep 2024 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GYOxmlB6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175041B86F3
	for <linux-fscrypt@vger.kernel.org>; Mon,  9 Sep 2024 13:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725886976; cv=none; b=E+oUMl7gpRew35YJRIm83FN3bAUePHQBM7ZCqnsXm8lThi8kTDHqQiMhXRJIoeaeI1PSS8U22fcAKIOrspBVjNHpWyzCnldP7AI7qar372Skaz1HV2M5qFvwPqMoNfnzHdT9HGHAulmwCEEMW00b7Vn8YmuJcJEFI3XfAGyPSGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725886976; c=relaxed/simple;
	bh=T3YX5/Lpd4lYkt45t/7q4cjSITWugSsonc6UgJRAfvs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CiMdx2TklBQezCsSzYq+rZeBEMaqJh0CfrDJMfhm5UC9jLCcNTY9y6ypYikYmpLj5eJ0fNAv/CCSU0qWWQtuwYlVgYSOeiVxt9j2h8CbbIDuajPlyx0onDCWvtrkLAIhkuV+hcKYa5a16FAUK6Z5H+iSFml1bwk3HlbLHkE/gz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GYOxmlB6; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a8d2daa2262so174441466b.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 09 Sep 2024 06:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1725886971; x=1726491771; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mMqU87htuX/vKBzsNQkDBJ4RpNR7Zr8uFLI9xAQvGQ=;
        b=GYOxmlB6cqxQooQnEt7X++w7jM/eK/CATiRIFTlUeVsvxT9Ux4sbdQFL2Yj3y9IIxs
         1/hT/mWfLkUwjQW8l2PNx5z/9dOebysSNFmr2JJncBXgRbJQhZb4hNCn3LQWhoQK3uLw
         MV1gOuwILIxvf+50GlQ3QALoWEgbLslRE+2Q64nHbx49SQ6N0NLiheIo0yVonh7UYmeT
         6SMAMkpaiXDARG4w8d4qLxh+oSDXZAPEZQh9Oct2MBiOFq71aPVkh8y/npv7+MtEzih2
         Awjsn9QaZNnSNtTZ7wnelsK2bB36E55nfpNa4W8U2xHredMXRNYHtN1ZsSdL2br2YUGd
         URtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725886971; x=1726491771;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mMqU87htuX/vKBzsNQkDBJ4RpNR7Zr8uFLI9xAQvGQ=;
        b=Awwzv6OmNXbQ3Al4kDb0PU2CpAmKVYxIAG9TxXetTtAO9CHTEeRFVhoXC2UQC7vFQU
         KP3rhINU2Tdp6a/rFtT0bgyZD/CHlEv8rwTSkhpgI85PYpPBwXIn3lJKXM+mXylHxUbk
         ZYQcXsbs03wmKYhbfWOeVRjvfKMdQeXf2iUJNCf0YdFPZDs6kYxfOsvM4ruQrzxeEsO4
         w7s9oGfBGjs4E8izTB/Npf8l7gl6dFIYWY2Ha4VHHA8cfVmg4n4XmiHfkelgK+9YNHEc
         cLQmYdJQO/zs49UIyRcrBWnvX0GnF7JjDetXDZ/4H4mbOGJenOfn5qUVrb633FCWGAs4
         LjVw==
X-Forwarded-Encrypted: i=1; AJvYcCVrTgAoPq8/S6erwEDAVSHmptka9MuDIHOQGTSDbLJG/96eS6GmZH/pOqA6Cm0lph4gU/Rk65YK88Db4tUB@vger.kernel.org
X-Gm-Message-State: AOJu0YygMnw9aiQgTJlNSSbinJJ01lDI548WG4CWbh6kIqF4KhGL1v0P
	ogPQT540fjVHwGJAuP4mXZzFTsCj3jIe4yuNL02yx1x7lijGe/DYcKzdx/Qt9U8=
X-Google-Smtp-Source: AGHT+IGBCWEcHjOnjDa3tv0OU9sQsIWi0rYKMo1x8pgZwqnvO0g9WWezq8axRIpo3yitGDVIG7HaOA==
X-Received: by 2002:a17:907:368a:b0:a86:8953:e1fe with SMTP id a640c23a62f3a-a8a8884be2cmr906103366b.47.1725886971281;
        Mon, 09 Sep 2024 06:02:51 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54abbsm337715666b.203.2024.09.09.06.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 06:02:51 -0700 (PDT)
Date: Mon, 9 Sep 2024 15:02:49 +0200
From: Petr Mladek <pmladek@suse.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
	linux-fscrypt@vger.kernel.org, linux-scsi@vger.kernel.org,
	bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND v2 16/19] lib/test_scanf: Include
 <linux/prandom.h> instead of <linux/random.h>
Message-ID: <Zt7x-dJF6RzEByBO@pathway.suse.cz>
References: <20240909075641.258968-1-ubizjak@gmail.com>
 <20240909075641.258968-17-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240909075641.258968-17-ubizjak@gmail.com>

On Mon 2024-09-09 09:53:59, Uros Bizjak wrote:
> Substitute the inclusion of <linux/random.h> header with
> <linux/prandom.h> to allow the removal of legacy inclusion
> of <linux/prandom.h> from <linux/random.h>.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>

I have just acked v1 and missed that there already is v2.
Just for record:

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

