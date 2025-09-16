Return-Path: <linux-fscrypt+bounces-840-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25711B58F12
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Sep 2025 09:23:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B9C181BC3856
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Sep 2025 07:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEFC2DFA26;
	Tue, 16 Sep 2025 07:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OmyX/1s/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA77D2DECDF
	for <linux-fscrypt@vger.kernel.org>; Tue, 16 Sep 2025 07:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007375; cv=none; b=JtB5BA0JyaIJyrgSsgorvFWJAbqa9bOaosglPshgIyBF46BbYO2aYTQ8sGeApU9gmDi3bb36szV1I24T2Fypk+x84NzwRVEUpfqRQdtyGnMorKrqz3lsGq/Nje9f44Q7cyLZJbHHz/8sRve07O2ubIJye5XWmuprQ49BqdbYDes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007375; c=relaxed/simple;
	bh=uyrGvi+dOJ8WEWpanikuzwBeyQzxDulRlvIFpz30cQc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eOfvmzedXFTy1upbyAhMHg9V3GGfX9/COYJQci9KcdbRylV5t7XENKrFkOpCunq2oY7v0a3W3DETGP28T1tc9xk7e3UibRGxlmvOabu/fy6jGZ6JvrGSf+B33JVqbqFDZ/NcqFixcG53qWbo0r0XgjrzFU0ORm2gvdT47EyQWA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OmyX/1s/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2570bf6058aso67062345ad.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 16 Sep 2025 00:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758007373; x=1758612173; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Spk+L+URf4FDnPrwupmkOtAzkHXeSWum03yPbQAWrZA=;
        b=OmyX/1s/4hB3DQqPvJI46i4ERXhCq3MzRnqbtqiB5fsxnpWKbLQi4zXP0m2Z0Xu5dA
         8NX4Yd124LnZWdpiKxCxQzgHGFNDGcip/gbSttR2bCYaZbXCKQkSMjrV4UFNEn6IDvw0
         yjWecvst3C8ubhTGWsDx/svHZeeyB40dpkWUyWWZTncJSQ7XyrUKlSncuTq7DQzczzz5
         vDwicRCNUFtvxNEkcdjppuhRQYmTea1qbIPfMozGp5MOnPkVMkvDhgV/yA29SmgXMt1e
         sYgynkWKL6cKm90PxDJy4cMUqHZI0U+yrdkJEMdLBiTh9Ac53Lr2Tky9F80/HmNZ6YXt
         VUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758007373; x=1758612173;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Spk+L+URf4FDnPrwupmkOtAzkHXeSWum03yPbQAWrZA=;
        b=ORdmKwFAaUpTRrjhb4+K0mpq7PfSgQZTBjI5+XuKnabyGZ/9kaKHiXQ1W38P+ya6TX
         oyqytBd6lnM4XV/q7gjD72g4zLJyIYJ4j4tO2r0cOgHjECebzI4g2poBakdE24up29XY
         8deiFaAFyVTSNGtZttsNtoaETFYy+ZA9mN3LhcufMVYXwoAlVha2gAxd2rq99HDAz6yJ
         XmuLP+PXe6Aq6iVNf0NQwnmX7EPOVxJzgcTu0WoSGfJi3tMeACVdQ6Q7fk0J2WANrdNa
         OVwRafWqZsHLGY/uJdH0oNLQBgxD9PuUMAH5xQgoQAzSXqChzGyE3+S07eN2yrlZc7Z8
         v+oA==
X-Forwarded-Encrypted: i=1; AJvYcCV3em68SOKbFsxxxbvMAXT7eALTUF95ekka/TJ/G1gGjfRiMmEas0kRHZWnoJWou2p+A2zUIzXmCcZBbqw9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5mJISNro/OED5tKucMAp0HiJjma4HKOrwFBnLa5AsMaMkUIEX
	tQcSzA2A1QO38koS2LThCDzVMdOY5xEcgQgzb6UVj8fpuRUfMAA4oAYe
X-Gm-Gg: ASbGncu1pXskISo08X7ovxJH9KRlouUjDL/nB3nAy+sLH9lLGajXiT55+vsm1zrVR+U
	0w8DqYIy6k5Mk8ZhRngFFSVv3Blppdm2Ybx3PP74mdtysnbgwniWiKMgTgFpOz00CqGhtPi46o2
	MbtSAYk5iLb4yfjG59QEoS/0X9+UqEVVDLmcuAkrL77iQG24DvyhU2eFmG+s1M4EBNGWG7Gi5SB
	u6ctaiyFnngQmWHlxwiCr4Vb3VaSmXKnzt1WsZsK7JiEezzMIGk33FgaszFtRkEn3T5VHNF+QxB
	CUJA3jltEfsHrrlgi9jd6fasi1TXCrIBmAl+FkZRo9ZWK5uZvZYhqu+B4GI2qr4RMlPitzmARVm
	7xcq52oYHJ7V3oq0Rl/vrDaWmF+DmSEIo42r8vBu/LuFRcVHH8cv8NYprudu9
X-Google-Smtp-Source: AGHT+IE+ovHzdEZ0Rb3pICHfqDJkMW30WK0/jUJIjArPYj7OENVv548+kflQE35w1soKYEhXuKbDjQ==
X-Received: by 2002:a17:902:f606:b0:264:8a8d:92e8 with SMTP id d9443c01a7336-2648a8da599mr101953445ad.59.1758007373082;
        Tue, 16 Sep 2025 00:22:53 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-265e18ea009sm55155295ad.74.2025.09.16.00.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 00:22:52 -0700 (PDT)
Date: Tue, 16 Sep 2025 15:22:48 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>, akpm@linux-foundation.org,
	axboe@kernel.dk, ceph-devel@vger.kernel.org, ebiggers@kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	xiubli@redhat.com
Subject: Re: [PATCH v2 1/5] lib/base64: Replace strchr() for better
 performance
Message-ID: <aMkQSIw4eHoDAED/@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
 <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
 <aML4FLHPvjELZR4W@visitorckw-System-Product-Name>
 <aML6/BuXLf4s/XYX@visitorckw-System-Product-Name>
 <20250914211243.74bdee2a@pumpkin>
 <aMfFOoQIIdMkVdYl@visitorckw-System-Product-Name>
 <20250915120220.6bab7941@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250915120220.6bab7941@pumpkin>

On Mon, Sep 15, 2025 at 12:02:20PM +0100, David Laight wrote:
> On Mon, 15 Sep 2025 15:50:18 +0800
> Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > On Sun, Sep 14, 2025 at 09:12:43PM +0100, David Laight wrote:
> > > On Fri, 12 Sep 2025 00:38:20 +0800
> > > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > > 
> > > ...   
> > > > Or I just realized that since different base64 tables only differ in the
> > > > last two characters, we could allocate a 256 entry reverse table inside
> > > > the base64 function and set the mapping for those two characters. That
> > > > way, users wouldn't need to pass in a reverse table. The downside is that
> > > > this would significantly increase the function's stack size.  
> > > 
> > > How many different variants are there?  
> > 
> > Currently there are 3 variants:
> > RFC 4648 (standard), RFC 4648 (base64url), and RFC 3501.
> > They use "+/", "-_", and "+," respectively for the last two characters.
> 
> So always decoding "+-" to 62 and "/_," to 63 would just miss a few error
> cases - which may not matter.
> 
> > 
> > > IIRC there are only are two common ones.
> > > (and it might not matter is the decoder accepted both sets since I'm
> > > pretty sure the issue is that '/' can't be used because it has already
> > > been treated as a separator.)
> > > 
> > > Since the code only has to handle in-kernel users - which presumably
> > > use a fixed table for each call site, they only need to pass in
> > > an identifier for the table.
> > > That would mean they can use the same identifier for encode and decode,
> > > and the tables themselves wouldn't be replicated and would be part of
> > > the implementation.
> > >   
> > So maybe we can define an enum in the header like this:
> > 
> > enum base64_variant {
> >     BASE64_STD,       /* RFC 4648 (standard) */ 
> >     BASE64_URLSAFE,   /* RFC 4648 (base64url) */ 
> >     BASE64_IMAP,      /* RFC 3501 */ 
> > };
> > 
> > Then the enum value can be passed as a parameter to base64_encode/decode,
> > and in base64.c we can define the tables and reverse tables like this:
> > 
> > static const char base64_tables[][64] = {
> >     [BASE64_STD] = "ABC...+/",
> >     [BASE64_URLSAFE] = "ABC...-_",
> >     [BASE64_IMAP] = "ABC...+,",
> > };
> > 
> > What do you think about this approach?
> 
> That is the sort of thing I was thinking about.
> 
> It even lets you change the implementation without changing the callers.
> For instance BASE64_STD could actually be a pointer to an incomplete
> struct that contains the lookup tables.
> 
> Initialising the decode table is going to be a PITA.
> You probably want 'signed char' with -1 for the invalid characters.
> Then if any of the four characters for a 24bit output are invalid
> the 24bit value will be negative.
> 
Thanks for the feedback.
so for the next version of the patch, I plan to use a 3×64 encode
table and a 3×256 reverse table.
Does this approach sound good to everyone?

Regards,
Kuan-Wei


