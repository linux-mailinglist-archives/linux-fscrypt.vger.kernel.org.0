Return-Path: <linux-fscrypt+bounces-838-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CD1B57204
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Sep 2025 09:52:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBF1318904C6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Sep 2025 07:52:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED242EAD0A;
	Mon, 15 Sep 2025 07:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFwBi5al"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1D32D5410
	for <linux-fscrypt@vger.kernel.org>; Mon, 15 Sep 2025 07:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757922625; cv=none; b=oR6J4C8972lA/0SU7KZjzSRjCyWy990sYBIiNCcwUCiSi3hXDRwnKGycNrWosXK+qpTswZL0z/zOyjwpiHOsrp8H2PgPpcBjLbAHrCrYaZYk5jInBfjbhZ8A/gMxN4Vkbv/FXe2uGpGcr1Oau9Ck4faSem2hK1is6kHXDA7OHk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757922625; c=relaxed/simple;
	bh=4x0K4C7BS/KwAtlKECA00SnfM/ZMwosnoHpPoGRiQlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aH+v3b9J/qyTZ4PQVyDv4v4VETZcYgXPZN6axnN7EgznMJ9LInQNPdFWAAk/W7f6x6QarfbsokJExhZoFez6OCfdI6CgEQBZSJcXzSzX+zQ6F0iHGMKmNTzTtW542TlYojLDywHX5uFFRnm80wIsPCod4dQQ8jO3xW1HGigpmsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFwBi5al; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77616dce48cso1804882b3a.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 15 Sep 2025 00:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757922623; x=1758527423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dcMYUn+TNptTLlFhWnaY6U4bXh0X9SnLYkpEfFnsdG4=;
        b=WFwBi5alFZCWpua/X9WOy1zjfkhRaxpF0KB4vE8hYiQ4A9o7HLApZWW0J8MRuF8sH/
         qQg7yb4dSEMLwCeoZN0alpy0eQwr5TcclcsisWxy/oMX3iOV86YMxQ4GAJF1SbvYbYbw
         RUszJhQflV5fUdHRJafnsfoB1mtVA21EsljFemtbGXuYWTU65is0MbCfrAgCEtCGlnVe
         A+JCZAWCfD/Dk41+Ayq43d4waZjOUaoRFSIGLB/24G1kwYN2b593rwSf6Sdxj3z9rKxx
         eNBTcBxoxsJydB3eKf70eHTflDTK4mH6y7m9oUx7SEKkB9Q1koZhiZN/Bd0gneR84D3p
         ADEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757922623; x=1758527423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dcMYUn+TNptTLlFhWnaY6U4bXh0X9SnLYkpEfFnsdG4=;
        b=Dj2guMtro64z3+SCLFWt/dayssMP6ItgxjirhCzbl8YkJdZKSRCsew04Vp8slW8z94
         qvQr2laobRJulSLNrjCGt3or+c7PKCDCZkFDyssyxbAFapcOwIr0pGFhlrbvtfuxSoad
         dF5I2p53MrJfTcu7d2a3fCRXDmgt0VuiT8qU149Vah38KSMZABPHqTmRVZNp4wwHv8Se
         uZdVm1y5RR9SIJYZm6qoih19qy/LbrNUdeM+Roe0Gp01jkDaPWEb9Twre6w9asfXB9xg
         VNx3mdEMwsHGzyj3I+BKLHvnTLlohsh6ZkZW8edMOez3ipzIJzV2F1VhS2FR4yiq9AEu
         G8YQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxHQPFrD987MXqtCnfqA2CNuxGyHpbgjC2ZutA2qKIQfvn7hoFXIUKA23t4NQTLfUjRWjvB3+OVLECQN9H@vger.kernel.org
X-Gm-Message-State: AOJu0YyPEiaUMyQx9bmLqJg4br71Xv4taD8uADmQnGsOzivbJcZJJmPi
	zjUd49gOmE1so+/iwC0nLLwpI7ZJucGPfT8v185kLctHbif6HBCtnCE7
X-Gm-Gg: ASbGncu2NIYJIG2jvyoUGLwyNPb0J+NGJ0k776UqNwYKzuEuJj1Xj3ax1YfaX1WqLrw
	/tvfQfNQ32srhnjG1MhVBKKqPlkCiYEg8tZxftM8/7h/k+bsG/GeW4uGViN3FY4v6RZEYMiKkyM
	T4lfXqxRM4XOOjahkjkf4RbK2GYqeh4sNURwFLINO1G+i2qN9JYlZYqbuKymkNaUEW/nSk8LfYX
	nnTRT28rLOMhbxDMhjSLHUzg2y41UcVBkAhvIHcqo2RTqT85XIZrxOoFqI+lIzo5/BfVs/hc430
	mGgCOusVy/mkv6pKclBUsfflXk0prFN2kU/125M+ynzQx8mISy/B94BwqsxHx1ybOoOGvwn+Lzw
	zhe7Iuyyc6GmyVcG5vqVM9uLzd9JY5TcRh1YWbYX8/4YyRfbcSKqQCgB4yZBu0vlBerpIFHQ=
X-Google-Smtp-Source: AGHT+IHTVtvEPQ/WLcfDtdAFIsV0pStIbm5dUP0xXRfmxVxAtPMNXCVUzOVfpPLSg5MbeMeLt+S6Fw==
X-Received: by 2002:a05:6a00:21cb:b0:771:fbc3:f151 with SMTP id d2e1a72fcca58-77612163666mr14541329b3a.15.1757922622731;
        Mon, 15 Sep 2025 00:50:22 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77607c471dcsm12492926b3a.96.2025.09.15.00.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 00:50:22 -0700 (PDT)
Date: Mon, 15 Sep 2025 15:50:18 +0800
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
Message-ID: <aMfFOoQIIdMkVdYl@visitorckw-System-Product-Name>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911073204.574742-1-409411716@gms.tku.edu.tw>
 <CADUfDZqe2x+xaqs6M_BZm3nR=Ahu-quKbFNmKCv2QFb39qAYXg@mail.gmail.com>
 <aML4FLHPvjELZR4W@visitorckw-System-Product-Name>
 <aML6/BuXLf4s/XYX@visitorckw-System-Product-Name>
 <20250914211243.74bdee2a@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914211243.74bdee2a@pumpkin>

On Sun, Sep 14, 2025 at 09:12:43PM +0100, David Laight wrote:
> On Fri, 12 Sep 2025 00:38:20 +0800
> Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> ... 
> > Or I just realized that since different base64 tables only differ in the
> > last two characters, we could allocate a 256 entry reverse table inside
> > the base64 function and set the mapping for those two characters. That
> > way, users wouldn't need to pass in a reverse table. The downside is that
> > this would significantly increase the function's stack size.
> 
> How many different variants are there?

Currently there are 3 variants:
RFC 4648 (standard), RFC 4648 (base64url), and RFC 3501.
They use "+/", "-_", and "+," respectively for the last two characters.

> IIRC there are only are two common ones.
> (and it might not matter is the decoder accepted both sets since I'm
> pretty sure the issue is that '/' can't be used because it has already
> been treated as a separator.)
> 
> Since the code only has to handle in-kernel users - which presumably
> use a fixed table for each call site, they only need to pass in
> an identifier for the table.
> That would mean they can use the same identifier for encode and decode,
> and the tables themselves wouldn't be replicated and would be part of
> the implementation.
> 
So maybe we can define an enum in the header like this:

enum base64_variant {
    BASE64_STD,       /* RFC 4648 (standard) */ 
    BASE64_URLSAFE,   /* RFC 4648 (base64url) */ 
    BASE64_IMAP,      /* RFC 3501 */ 
};

Then the enum value can be passed as a parameter to base64_encode/decode,
and in base64.c we can define the tables and reverse tables like this:

static const char base64_tables[][64] = {
    [BASE64_STD] = "ABC...+/",
    [BASE64_URLSAFE] = "ABC...-_",
    [BASE64_IMAP] = "ABC...+,",
};

What do you think about this approach?

Regards,
Kuan-Wei


