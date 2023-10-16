Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1577CB26C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Oct 2023 20:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbjJPSXn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Oct 2023 14:23:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbjJPSXm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Oct 2023 14:23:42 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D52AAC
        for <linux-fscrypt@vger.kernel.org>; Mon, 16 Oct 2023 11:23:39 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-4180adafdc6so32710641cf.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 16 Oct 2023 11:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1697480618; x=1698085418; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOYKUfepen27nA77Lut7Ol5Mk35ukAs7DeLDiH//Idc=;
        b=de4VvUoFvw0Y4PUXnEuVIZ+IG+SfTc6AQFAKa3vRqxWnzVVq5GViJ5p9UbXntj1l/W
         35NMXoJ+ZRGKbvOl+6AxNFrhA6drBvfW0b1zyOVgwwZDDEEyrvXUebG9Mb/KQQi3dhLQ
         raTYW68KKy2TT6p5cJlm5q5U7CzOCeOdVVVrSpZPGP2YpR8CdWf8kkt/Hrs7ii/YDPKS
         uEIxMWP1JGKCSgq+SwCf7l0y6EkitF58jY3sWshtY04XnZWxXE1a2N07OXHzWN+ljOwi
         RQybvEJgXEPIJoZ1A64IOWhTpJt/BHN/srXvcLEjrvC5udPA7v3yLtMiOGknMMYS7lly
         2Xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697480618; x=1698085418;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOYKUfepen27nA77Lut7Ol5Mk35ukAs7DeLDiH//Idc=;
        b=kfIbuewrvLY+U0MOOlfSOY29en3RZTldjmJIJ2ojm+THEeUWfLVR5IHMXm0onXTqA4
         HquxbZCODbOeJD+x9rv1iVO1doUsu1wQ4TySL9IjJgNinAKT1leiBnVslOTFtLMSP/N7
         uRcWEAOGZaJ1nBybJ2a2nilXIBPL27LqmzEuECfD12Y7GxMpnSAxvuRfzOdsHfjAou7g
         5Ii70NPSnCPivAXtXDrBaOMSIhozohoWt4XDZ3BozRvCIV4gOW5XAbw+LK5kcDPaxNGf
         7z+L0aXVwlWQo6uBFMkT8sk6y/396p9y/xuTjPFrfgd6Hd9RxDZ8WtluxXZ9F/V8zbsW
         0m6w==
X-Gm-Message-State: AOJu0Yw4r7m4lbPtl+Hc5TyKLaritVPR98R74ybNT6u6GyRtVIfmHm05
        tUR6Oc4dOUg++5OiIf2TyGniNQ==
X-Google-Smtp-Source: AGHT+IEQpPBSiUxhEN9mRav2a+h1a/IHbGlSqbmA8O4xF4Kfhllw0H35Ry808yTYySipDi6RpVt9NA==
X-Received: by 2002:a05:622a:5c7:b0:410:9b45:d7ed with SMTP id d7-20020a05622a05c700b004109b45d7edmr132204qtb.56.1697480618693;
        Mon, 16 Oct 2023 11:23:38 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id h4-20020ac87444000000b004179e79069asm3204261qtr.21.2023.10.16.11.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 11:23:38 -0700 (PDT)
Date:   Mon, 16 Oct 2023 14:23:37 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fscrypt: track master key presence separately from secret
Message-ID: <20231016182337.GA2339326@perftesting>
References: <20231015061055.62673-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231015061055.62673-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Oct 14, 2023 at 11:10:55PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Master keys can be in one of three states: present, incompletely
> removed, and absent (as per FSCRYPT_KEY_STATUS_* used in the UAPI).
> Currently, the way that "present" is distinguished from "incompletely
> removed" internally is by whether ->mk_secret exists or not.
> 
> With extent-based encryption, it will be necessary to allow per-extent
> keys to be derived while the master key is incompletely removed, so that
> I/O on open files will reliably continue working after removal of the
> key has been initiated.  (We could allow I/O to sometimes fail in that
> case, but that seems problematic for reasons such as writes getting
> silently thrown away and diverging from the existing fscrypt semantics.)
> Therefore, when the filesystem is using extent-based encryption,
> ->mk_secret can't be wiped when the key becomes incompletely removed.
> 
> As a prerequisite for doing that, this patch makes the "present" state
> be tracked using a new field, ->mk_present.  No behavior is changed yet.
> 
> The basic idea here is borrowed from Josef Bacik's patch
> "fscrypt: use a flag to indicate that the master key is being evicted"
> (https://lore.kernel.org/r/e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com).
> I reimplemented it using a "present" bool instead of an "evicted" flag,
> fixed a couple bugs, and tried to update everything to be consistent.
> 
> Note: I considered adding a ->mk_status field instead, holding one of
> FSCRYPT_KEY_STATUS_*.  At first that seemed nice, but it ended up being
> more complex (despite simplifying FS_IOC_GET_ENCRYPTION_KEY_STATUS),
> since it would have introduced redundancy and had weird locking rules.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Based my fscrypt patches ontop of this one, ran tests with both btrfs and ext4
with it applied, in addition to my normal review stuff.  You can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
