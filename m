Return-Path: <linux-fscrypt+bounces-834-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD73B54432
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Sep 2025 09:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E90E480A15
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Sep 2025 07:51:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A8152D3735;
	Fri, 12 Sep 2025 07:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b="NHfPqkBO"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2B72D29CA
	for <linux-fscrypt@vger.kernel.org>; Fri, 12 Sep 2025 07:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757663494; cv=none; b=hyh1RdXwCxW7ILUxqzCovCd1WbOnd5S4fIFo9rGaWbiovKknAfiR2rzoJKFb3lefW/JTh76Zb9oMNmb5SgItK4cL9t3RyDAwQolrBBbDlEi7AxnYXAZf3vjQnWLSqoAsaKm9WDS/XkYeWXvw+X/OFtafk+TKvi36/30rdmaAAVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757663494; c=relaxed/simple;
	bh=/nCOtAcnhP6iXsdPDKExHl6CEK70Rn3V1zWzjtGkAjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YHVXZi7I66nQBAWq/Kw1DUbDRp9jAYndjVSycaC22DjbrGVt3tkZ2+bKu9UOjsJi3HLr6D9pl9+TNPtH23PrGm6z5OaJdHI3wyu9LiYFuTVRSkX6pUDL03Emkyx6N9ChYJa9Apny4ueTX9ORlOBUM8gz1EeC7p33l6J1N4p7koE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw; spf=pass smtp.mailfrom=gms.tku.edu.tw; dkim=pass (2048-bit key) header.d=gms-tku-edu-tw.20230601.gappssmtp.com header.i=@gms-tku-edu-tw.20230601.gappssmtp.com header.b=NHfPqkBO; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gms.tku.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gms.tku.edu.tw
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7741991159bso2395963b3a.0
        for <linux-fscrypt@vger.kernel.org>; Fri, 12 Sep 2025 00:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gms-tku-edu-tw.20230601.gappssmtp.com; s=20230601; t=1757663492; x=1758268292; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H5dGuAanKwsiY1ZqsKVkDAIjfNLSeHC2vPf4ogltoWw=;
        b=NHfPqkBO6IpVqSz6f+1Cnc18yRXdyF9DjK/HXMiE6pXswUizb6G8718m76bb+VW5Rk
         QDHXyq5y43TSQR6JQfKncB1ydlE+HLHQQahiRz91cbKABkOjtRDIxC8SJ7dou8ufBDD/
         scfhgN9ujlASqXvtj3UjnEfqkHQnj0gveUfWcIWdKbXxDW8vo81Wuf7eEpen5AGRH1Rg
         IHRxLGMgB+Fp/dp3mA71hr22XWxdo+l3S0+CV16HVlyCHKCHJYKOK1zS09zNQ4Mh7iAD
         zK9EB25ddpb5qr0ZC+ifHbZ1DoGE4q0DqVIIqYjeaMG4ToJktcYGlsHiPxpfqOAT9dBG
         /T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757663492; x=1758268292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5dGuAanKwsiY1ZqsKVkDAIjfNLSeHC2vPf4ogltoWw=;
        b=e64Ly6DctOYOFEiJBTuTKpeObVJcX9HzL8GfizgNxCfo4O3r/MiRsXr7MghK7cT6mZ
         Vf8cqqff1TIzR4StUrYLZqFNFj+ai9yurU7YsKrbw4dompxp0Apvu9qFUgoHlTFBDgXk
         6QnO9NMGqHniTSSYGutjX12KvmF+G0LOfEuj82rw4brJOt5uz9oyirEzrJ3Fib1aNKS2
         8S+qpbynAOEnGs8aKu3C/9YiNoYWgNNxyR4t0IIUyWHjfgg7PwnCzkWN4Gdb7Y2K1IX0
         AMMmBu3Wb9TE1dA1l1+rdz0hLdvIi6E7EGSpeHXwvrbwkgTE/OerOKjTnCbxvmoNkmol
         m7aA==
X-Forwarded-Encrypted: i=1; AJvYcCWsfa0JTxR5HTowXmS8wHTGqH8hiCmYQdhk6XBOwyui94IlqLuViBSTHGRzlMCFZoJlyoRw4a8cA5o4xL43@vger.kernel.org
X-Gm-Message-State: AOJu0YyzjCZCvZp/46g4nPE/BLx+GcS5YHlWkb48weowJ30c6lZIMeTC
	0Dv7+hdKV3b4+F9drM/GSRhWDh54K21P564IsoRRJQG39owobX+R9iJZpWYwvYNBohc=
X-Gm-Gg: ASbGncsy9eMbSrz5Oyjjt6lk6hcXUPGGK774gf5JHNJ1jbwC4I/V1Ofmu4hWNn4dff+
	lSmMUPUq2k15h1b5/9N+TYp/rVTWLdIrg1Ukr2SQ5UBwzHx5v3u1sO10aZ7XDzKXoo3HFTHFbe0
	U/JUej8+0E+QfjPyEK8AI8Z6RnGWqrvKIN16bsC0/ls1xLunFjrTcmiaNlZA1emxP8N8vTRlRhv
	g5N1u6q+fMKrTun25LAr9cLNIlh1GjFGypByOSkHF1nNeVAEeAhbntz2dvn1kF35ZSOvrbDYRJW
	tsMozMv9BwM94JBcMqhpkSH0j6DKvNKZRkSJM5gJVfAra18h7M9DwmfrNIoD/Aw9HavLsQdVJmp
	Gg+1/sNcFlf9Kl9p2cM2y15hI82bOa8NgKeNc3AIVmb3G
X-Google-Smtp-Source: AGHT+IFtDrLHbUf9AliWqdyLS/y+bqUNiq48Oi6Y5dHmTb/VowvDyGiDtwNlsYwwblHsCPFZzZ+p4Q==
X-Received: by 2002:a05:6a20:7d86:b0:24e:a19:7e91 with SMTP id adf61e73a8af0-26029f9e7f9mr2593600637.5.1757663491712;
        Fri, 12 Sep 2025 00:51:31 -0700 (PDT)
Received: from wu-Pro-E500-G6-WS720T ([2001:288:7001:2703:9e14:1074:637d:9ff6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa1c54sm3880886a12.50.2025.09.12.00.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 00:51:30 -0700 (PDT)
Date: Fri, 12 Sep 2025 15:51:26 +0800
From: Guan-Chun Wu <409411716@gms.tku.edu.tw>
To: Eric Biggers <ebiggers@kernel.org>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 4/5] fscrypt: replace local base64url helpers with
 generic lib/base64 helpers
Message-ID: <aMPQ/sJJmgpZvDsY@wu-Pro-E500-G6-WS720T>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074556.691401-1-409411716@gms.tku.edu.tw>
 <20250911184705.GD1376@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911184705.GD1376@sol>

Hi Eric,

On Thu, Sep 11, 2025 at 11:47:05AM -0700, Eric Biggers wrote:
> On Thu, Sep 11, 2025 at 03:45:56PM +0800, Guan-Chun Wu wrote:
> > Replace the existing local base64url encoding and decoding functions in
> > fscrypt with the generic base64_encode_custom and base64_decode_custom
> > helpers from the kernel's lib/base64 library.
> 
> But those aren't the functions that are actually used.
> 

I'll update the commit message. I meant base64_encode and base64_decode.

> > This removes custom implementations in fscrypt, reduces code duplication,
> > and leverages the well-maintained,
> 
> Who is maintaining lib/base64.c?  I guess Andrew?
> 

Yes, Andrew is maintaining lib/base64.c.

> > standard base64 code within the kernel.
> 
> fscrypt uses "base64url", not "base64".
> 

You're right, I'll update the commit message in the next version.

> >  /* Encoded size of max-size no-key name */
> >  #define FSCRYPT_NOKEY_NAME_MAX_ENCODED \
> > -		FSCRYPT_BASE64URL_CHARS(FSCRYPT_NOKEY_NAME_MAX)
> > +		BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX)
> 
> Does BASE64_CHARS() include '=' padding or not?
> 
> - Eric

No, BASE64_CHARS() doesn't include the '=' padding; it's defined as #define BASE64_CHARS(nbytes) DIV_ROUND_UP((nbytes) * 4, 3).

Best regards,
Guan-chun

