Return-Path: <linux-fscrypt+bounces-607-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33AE3A30272
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2025 05:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 359EF7A320B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Feb 2025 04:06:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1319E1D5ADC;
	Tue, 11 Feb 2025 04:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FfFJqdtH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0A8615A
	for <linux-fscrypt@vger.kernel.org>; Tue, 11 Feb 2025 04:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739246817; cv=none; b=t1vxttyt2FRwyRT/4Fh509jm0oRKZCDvrsyBVmKdKEGfaKQKgh8/7NQ4UuKoPP7NPf8jiCoPQu8fqRt/vIiaEToNB+P8F1ZPoY1TaxrOw/UwtR+3q9VV/daInG1+6OKtOOwwt8ciD9BietkmHaH0GB0WIyIkaAiNGy1MCvGr7Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739246817; c=relaxed/simple;
	bh=SFwBpriK6aKH76/suGo9jiL8C38OSxxV9ZD2Dh2uFn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E9v58FMxeFmxtFPPyMQa/zlrnSUZRfjziHo1wASHTu7O/cLSGBH1Rcan7vQnfCwdMoxJPsoDDoJdpOGmviBjZoKLoND2ys/K8D/oIZNjFzU0MuRxrlMt0ugtVO7GmDMiVP812QRTrgV1WWS/q86LBDPXTstgi2o3QXqJlFCHF8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FfFJqdtH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739246813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8K2ET0rMMayMt4C4OL5IaPRn+ANOFbJuWCLFSQnXZM=;
	b=FfFJqdtHqZBf9r7vrp6fNALfuNtR304q2hcEJu6at1xQkzmxLio4oPK9jNYJfh/qI+qcpZ
	1K7i6IkAwTUxrys9JBUfjf2nZbqNwZ4cdYUoAZqbO31ttpaKTxbbldXdRjng4Z+sJbE+p2
	Y5Vg3nmWIW8AI4tsygLlE+5z8qqMxe0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-9FI_ojZdMBez2FgfDiQQPg-1; Mon, 10 Feb 2025 23:06:50 -0500
X-MC-Unique: 9FI_ojZdMBez2FgfDiQQPg-1
X-Mimecast-MFC-AGG-ID: 9FI_ojZdMBez2FgfDiQQPg
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-2fa57c42965so4982510a91.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Feb 2025 20:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739246808; x=1739851608;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8K2ET0rMMayMt4C4OL5IaPRn+ANOFbJuWCLFSQnXZM=;
        b=OJTof6+GhSihTIxG2dBhZtyUJISzJzNZ9NiitXeXGC61yswEibZM7m7NctjpUFF+Gl
         8SoEr4W4IkLQ1F8Kx5szCPaJkcJoNKGxfEaC8zCjzF2rnjhoTyY6TWolpZ2zHBrHDZeK
         xEVwretPTBw+rx5sSv7s6L4wGcUYLaD2Mt+oz93GR8+Y338VzQZ/hLCm4EmPIbuXc9Zb
         eigeZM+prhN41duTiJhMngmckJaqEN3E5p1cAzX9uFT/jLNl0MMUmDP7JZmSERIhBVUs
         SyqYmkPo6m6V1/KRbCdwg2lMBmWkdVMYDCzOjriBKilboG9mRJEWGzHjrHCzHBNk2f7b
         I0fg==
X-Forwarded-Encrypted: i=1; AJvYcCXPW5wtHDbWN9+nSW9F5qiWwY1ewjVUeJXTQLYMw+RX0aP7XRJ53JpvIDnV3xUe/9f0q3AoRxqyfTwWjkoA@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe/zWE2/sT+S1xMf9R4fcFwtkQ4rvbZvaAChkyEStb8AaMtnvS
	ZS+jKi+oH9Mq9Jgbo0NrnZLrNjY/EhVO5UAo7L7kFImxn7u/DW7tEK6c4dwzU7AcKx6pjVjXexX
	9Ry4SHcoKo5YtJhXfTtWuzN9G0HTdyt8ZdxAzCp8xNLyJRrhyzbxjULvpBjmRKvcVlReruLvkJw
	==
X-Gm-Gg: ASbGnctEVsgRkRn6v6dq4xfBZvqbSyDcGhnZXawcjxz77S+Y9wdpyT8+oaT0TIH+hzV
	LOYU2Zou8oj8ZV1Csb2HDUHAzPzvqMoyQ6BBFPvyZMU55wi5ihch7gJiGRBFrDnx4TRzrGh8XmE
	qTOnmw1seMTTlUpdLnHjbeOsBfMRyQe/JJZ+Zb8DJ6BV18PIgfYNYXpLg+j2op5vXC1twjy9Am9
	usatWC5Q0FCjDBPlJ92F07D+5YV4WX8rZ+nmX2qAY0EHe1FLRvuCQcfXxbPEC73GbAfKnrlZ77v
	6OadBxN2fYvBnksjyLGGlC0zt274UUpjLom44oI8OMDU9A==
X-Received: by 2002:a05:6a21:3a8d:b0:1e1:e2d9:3f31 with SMTP id adf61e73a8af0-1ee03a3d164mr26182863637.16.1739246808098;
        Mon, 10 Feb 2025 20:06:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFXY4fefQ+Fei+tDRglsHR2l5WFDIfLtSWy/49QLIRJBvM1w1MvRypx1wNj+S5LzmwEgxFCxg==
X-Received: by 2002:a05:6a21:3a8d:b0:1e1:e2d9:3f31 with SMTP id adf61e73a8af0-1ee03a3d164mr26182844637.16.1739246807809;
        Mon, 10 Feb 2025 20:06:47 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048bf1421sm8603567b3a.101.2025.02.10.20.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Feb 2025 20:06:47 -0800 (PST)
Date: Tue, 11 Feb 2025 12:06:43 +0800
From: Zorro Lang <zlang@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>,
	linux-fscrypt@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [xfstests PATCH] fscrypt-crypt-util: fix KDF contexts for SM8650
Message-ID: <20250211040643.jjpssyx6n76rwxfb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250118072336.605023-1-ebiggers@kernel.org>
 <20250210204039.GB348261@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250210204039.GB348261@sol.localdomain>

On Mon, Feb 10, 2025 at 12:40:39PM -0800, Eric Biggers wrote:
> On Fri, Jan 17, 2025 at 11:23:36PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Update the KDF contexts to match those actually used on SM8650.  This
> > turns out to be needed for the hardware-wrapped key tests generic/368
> > and generic/369 to pass on the SM8650 HDK (now that I have one to
> > actually test it).  Apparently the contexts changed between the
> > prototype version I tested a couple years ago and the final version.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  src/fscrypt-crypt-util.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Ping.  Zorro, could you apply this please?  Thanks!

Sure Eric. I don't have a hardware to give it a test, but other cases which
use fscrypt-crypt-util test passed. And I trust you much on this change, so

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> - Eric
> 


