Return-Path: <linux-fscrypt+bounces-163-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1141847912
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Feb 2024 20:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B1EEC296CFD
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Feb 2024 19:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6163C12C7EE;
	Fri,  2 Feb 2024 18:52:01 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA023126F26
	for <linux-fscrypt@vger.kernel.org>; Fri,  2 Feb 2024 18:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706899921; cv=none; b=Zq4nRLYeaASiK7M+REbUnZGipAo/S3KeAMA9ApSL3RU0cRuw9rsFf5IlBoowraD1UIaBBSyBMTQYPMMa54vlaa08bdKXdxmVT6Fm0DPYVfdtl+LBhQHL75aQ7a1bNowDHfKduqfG6VqF1Jo5c7hUXRny+Z36PAdEf+pHO51u0B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706899921; c=relaxed/simple;
	bh=AW0oiHNRWLwkj7DtXqlQs47sAiZxxTl/D0PavmFNNso=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GvARSToDZaV6xr1xntEvnVGeGzjyLzphJIfKtfqW7quhjtEgKlU7gqb3X6D6MbR0vXphY6vBV42PYlWyNC18KSHwTUgWDYunJgkcWqxwYj8Jg+QrkVyBTS5A4RQVy1L8Q5BIXDgL7Lepszc20CaPAq3Yw5ma+AJMMBqPtCCc50A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-6041779e75eso25487557b3.3
        for <linux-fscrypt@vger.kernel.org>; Fri, 02 Feb 2024 10:51:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706899917; x=1707504717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ph1IYkDrzTvpiJ6XKsi8PGQTmUGSqWuwAi9y4521vtI=;
        b=tkXs0UINYA6YfyLYpvkvJ00RtzKJr8dh6gB/KMdBK8Kp+tZ3Kxg7K/gPjpEs2sJ+NF
         Jtcum/MhA08054hG3wUD8FbfGGvSlDcwHJJZAgc7BwFQF+OYG8h+qZJvfrbZYUFHBQZ0
         K1Np8VxLrD/Ww87RmoXRpa5lxu4e7FJdqwSytTtjWR9dDB6/+oMPxauSPJL9840CAmLt
         9Lcct6/UMtP1cIDQn7NhL62HSqQaV2RSc4KzxctZHqbAOPN/e5M24rQ0JuoJIGObBxz8
         /+0m65mghGVLdksegh/Kr6GABgtlVmwjlXT16PpkiKdMNQlH5i4Tx5ZKW9HSxKy7tzrv
         uhEg==
X-Gm-Message-State: AOJu0YyGdFiFpBKMBgB1ESUMOuIqyHkCmzDNI6tIjokc4pGP1WVNnNE7
	40pP2Vgc8xWrm+b6BJ4AZITjLUPnulkMzfBpklApvYjBf0WF0oHGr+3jC75sRA==
X-Google-Smtp-Source: AGHT+IHzSoy9sIqCe1trQy3sTBHypeAjU5TzDYa4rgE3LRbYzokk0H0wQROhLE8FkkUDyWBrdMh9UA==
X-Received: by 2002:a81:ac67:0:b0:5ff:76c5:f638 with SMTP id z39-20020a81ac67000000b005ff76c5f638mr3220501ywj.21.1706899917047;
        Fri, 02 Feb 2024 10:51:57 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCU5x0xesXnhPy9m+vbgtSeOvE2jww0i9Tjwtxsc+mWeiLpLHghmb3RgoPY4YlidsLDnh9x3De8P3Dt9d1SJ7zGdzjLP/BsqZYFGfpX1puybWRRjrAAqPrg6Ktc8pax+N869iCi2gOcJbZZaWcQSktZSCeyT40FCSqnrcPP3UwjwDlVFLZoMx8qVs2n3M7YiWUkTgPNrsW2NRUz+4Zo6ugS/86mC8XQAAWeTDT30JbBuV1XpdNX6nasJOGugz/oIEXSbcc560klHxu8kvj/237+hpVYVAeZAK9DwJZWTY0Tjhca9jtDd8n/nQxV302xWv0NqEu1BA4vMtf6AnIObINSGPRgeKt4GPfSHZxE4BMcZr6ONdXo9a2X1LVp17xYh7WlvWMXkIoRv7dYsAL3mW1QhG7rG1PVX33RFouQqbcgRQGIZ3FOUR0iO+rJU1ytJnDXNxfAEgAJfYvyWTd/N/s5vToYaZSWrWvg8t0HVG3/vcmIwTys+Rw7VuwvRAkdhSN2dhSyqk54dvFfYaKBoy2VbmNiA9bbraj9ohjRfLOxXqCPhCU7j6S9XCfmrOZOScFaQLApOiuY/h1xNV0lnsal7Tv+3
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id gd19-20020a05622a5c1300b0042992b06012sm1080669qtb.2.2024.02.02.10.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Feb 2024 10:51:56 -0800 (PST)
Date: Fri, 2 Feb 2024 13:51:55 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Fan Wu <wufan@linux.microsoft.com>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
	serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
	axboe@kernel.dk, agk@redhat.com, eparis@redhat.com,
	paul@paul-moore.com, linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev, audit@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v12 12/20] dm verity: set DM_TARGET_SINGLETON feature
 flag
Message-ID: <Zb05y2cl3T9rxRJZ@redhat.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
 <1706654228-17180-13-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1706654228-17180-13-git-send-email-wufan@linux.microsoft.com>

On Tue, Jan 30 2024 at  5:37P -0500,
Fan Wu <wufan@linux.microsoft.com> wrote:

> The device-mapper has a flag to mark targets as singleton, which is a
> required flag for immutable targets. Without this flag, multiple
> dm-verity targets can be added to a mapped device, which has no
> practical use cases and will let dm_table_get_immutable_target return
> NULL. This patch adds the missing flag, restricting only one
> dm-verity target per mapped device.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> 
> ---
> v1-v10:
>   + Not present
> 
> v11:
>   + Introduced
> 
> v12:
>   + No changes
> ---
>  drivers/md/dm-verity-target.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index 14e58ae70521..66a850c02be4 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -1507,7 +1507,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
>  
>  static struct target_type verity_target = {
>  	.name		= "verity",
> -	.features	= DM_TARGET_IMMUTABLE,
> +	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
>  	.version	= {1, 9, 0},
>  	.module		= THIS_MODULE,
>  	.ctr		= verity_ctr,
> -- 
> 2.43.0
> 
> 

It is true this change will cause dm_table_get_immutable_target() to
not return NULL, but: I'm curious how that is meaningful in the
context of dm-verity? (given the only caller of
dm_table_get_immutable_target() is request-based DM code in DM core.)

Thanks,
Mike

