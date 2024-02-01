Return-Path: <linux-fscrypt+bounces-162-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A58B844F46
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 03:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F40F8B25C57
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Feb 2024 02:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F1063A1AB;
	Thu,  1 Feb 2024 02:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JDkzbTij"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124B53A1B4
	for <linux-fscrypt@vger.kernel.org>; Thu,  1 Feb 2024 02:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706756388; cv=none; b=Sr0+rSsk2nQOqxEVx+B/fysmU/DmIHLuAXRGlLbKH08RdY7tkIGVYsYMLcrHaqHr/f38/WQoz4yCPp4OTlT/2fO/T2S77VJJw7gTeeHhUhrP/ALFoR75JexZhoJS2AAmIquY6hOoVjkGvDS/gUV7TkYSggwLtk2UsAoRnrViI/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706756388; c=relaxed/simple;
	bh=5gKmwqTiX//bw8dcuurwVdti6uUWSqDtZl+dcrFZ1I4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L5dApNhO3dW5b7srVNv0NxKfzcoQ8UyXT/w8b4nFPCYaQNznIWgOIsF05yVUxNvR2NABZZsDtU+l1Xok/4eMdSz0yLcAQV6NwdfUZ1O/ijDqmCXhUuUeIFyQdsfD3EbKezCnQQyCq79J+p1zI3/H8eQ4JNqTPo3332UnEscnksw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JDkzbTij; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706756384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0K09n4KM4GfA4ieYr3u7htlPmiCBvQiYCmB4ilutQSI=;
	b=JDkzbTijMGR1Tpwh4grFA5TIzH2nQuYbHUQjCXd4+muHBp2OdTsACmo1VJCfKwFS4hCH+j
	tjhJFBIbzPRUVBOEgOMqiKO5xccSacbCthR1ogVtBpZxj4LECQUKR2aNIs1PYQYyOpxw9u
	M0dAEgk0b6DF55dKxJkm8Tu6ehRjW8g=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-I1hYocdEMyebAnH2DDDQig-1; Wed, 31 Jan 2024 21:59:42 -0500
X-MC-Unique: I1hYocdEMyebAnH2DDDQig-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-292bc8b6b7cso391636a91.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 31 Jan 2024 18:59:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706756381; x=1707361181;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0K09n4KM4GfA4ieYr3u7htlPmiCBvQiYCmB4ilutQSI=;
        b=ppHhv2QMMS0Mxkg0EYrLlfGBRRzUEFTUhi8LxBrJLeX97XoQyopBQMn7N4EVsgFXIO
         jnQP9a8GzzIFcVuLgBRyhpq+ERWVZ7pRNKHMCMw3LY0HMtMTXpYbliMDXgMwKmxZKkpL
         CMD+QkHtbEHy7egbzJ0XUxS90iTUkAYhHIKq1OOVmyW7F2XvYEgnRdUW31eL5ycNZs4S
         uqBxH0AizeRvcLKJPl/Rc6RsS7yEUYKUXc1N3O7NeEHLGHcXE8FsQYc7HFGHopQY9DMx
         7B0rgMf/BffVllpmtIHq3SFbLBLlH4hmNF4AIaOWkXB5o/My5WSJW74wcuKlhetIMpR7
         i6hg==
X-Gm-Message-State: AOJu0YxK0pf3zgyuNaqxkiJ0o4LVZbxDQnUYirOuIJJKDx5NBmPJ+rIq
	JNhHZ1OVyvwMw4sAa/T+Gj0ZnQfEd3ihcA0ALfgp00Lb1YzP+ymo3g9Mu6vHEBJ/2zzOUjvvpZz
	b83w8f9N9IwB1GOOgVEiP33IZH0QgOaPi1LLHk3M+g/rPyIv1I+ZSDt6nJxpMK9g=
X-Received: by 2002:a17:90a:ce18:b0:294:7038:777d with SMTP id f24-20020a17090ace1800b002947038777dmr3901977pju.13.1706756381070;
        Wed, 31 Jan 2024 18:59:41 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF0ZQ2E5GxhjYagXcM2WpAQ5CV3eNZ5+T0wmWcpW9bT04Oir0NC6ttw5pobxxz+SLpJhTJo0Q==
X-Received: by 2002:a17:90a:ce18:b0:294:7038:777d with SMTP id f24-20020a17090ace1800b002947038777dmr3901969pju.13.1706756380799;
        Wed, 31 Jan 2024 18:59:40 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVsjvS8L1o8MG8eurFUAa7zDMjUJgz7DPAVdr13C1+E7gDNRiJUiMRYodfSCKOiaKxZOxE2VZtzSnPzmXvRWCQ2VUGoeu++Ovg8wbdO/9vvgRQDc1tkd1CYI6sYttHd/336382BGsRYwjCIaCII8i/GcCsvSKaYKPXw+HLH869NJx6RTmpLkDQt3Ktfjim/OnmkAOQsbDk8KFRYy43G5MrZgajVitt3fqRzTC5hn2s21grwSOR/vz9yaZzHilnZPEn3XTIDswmDHsA4MVUpdQG81c8CH3jOjJ5KzL7RBg==
Received: from [10.72.113.26] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v6-20020a17090a088600b00295be790dfesm2225567pjc.17.2024.01.31.18.59.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 18:59:40 -0800 (PST)
Message-ID: <2fccdb02-3b66-40b9-a0d7-a79fe7c5580a@redhat.com>
Date: Thu, 1 Feb 2024 10:59:35 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fscrypt: to make sure the inode->i_blkbits is
 correctly set
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
 linux-kernel@vger.kernel.org, idryomov@gmail.com,
 ceph-devel@vger.kernel.org, jlayton@kernel.org, vshankar@redhat.com,
 mchangir@redhat.com
References: <20240201003525.1788594-1-xiubli@redhat.com>
 <20240201024828.GA1526@sol.localdomain>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20240201024828.GA1526@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/1/24 10:48, Eric Biggers wrote:
> On Thu, Feb 01, 2024 at 08:35:25AM +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> The inode->i_blkbits should be already set before calling
>> fscrypt_get_encryption_info() and it will use this to setup the
>> ci_data_unit_bits later.
>>
>> URL: https://tracker.ceph.com/issues/64035
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> Thanks, applied.  I adjusted the commit message to make it clear what the patch
> actually does:
>
> commit 5befc19caec93f0088595b4d28baf10658c27a0f
> Author: Xiubo Li <xiubli@redhat.com>
> Date:   Thu Feb 1 08:35:25 2024 +0800
>
>      fscrypt: explicitly require that inode->i_blkbits be set
>
>      Document that fscrypt_prepare_new_inode() requires inode->i_blkbits to
>      be set, and make it WARN if it's not.  This would have made the CephFS
>      bug https://tracker.ceph.com/issues/64035 a bit easier to debug.
>
>      Signed-off-by: Xiubo Li <xiubli@redhat.com>
>      Link: https://lore.kernel.org/r/20240201003525.1788594-1-xiubli@redhat.com
>      Signed-off-by: Eric Biggers <ebiggers@google.com>
>
Ack, thanks Eric.

- Xiubo



