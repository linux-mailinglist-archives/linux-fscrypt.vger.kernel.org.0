Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399A941B277
	for <lists+linux-fscrypt@lfdr.de>; Tue, 28 Sep 2021 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241432AbhI1PBd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 28 Sep 2021 11:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241371AbhI1PBd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 28 Sep 2021 11:01:33 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F898C061745
        for <linux-fscrypt@vger.kernel.org>; Tue, 28 Sep 2021 07:59:53 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id i4so93901461lfv.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 28 Sep 2021 07:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fInY95no8O0JEStBsdbpcymzt287B66Fcqaxhkug+c=;
        b=FfNByYfUegGHsII+I3f5TVFbSZkKQ34sMp4OH9feQ01FDoaO1JVJtg1jZ8hbAyyE3h
         +o/QtI4Gycrr4pn0Wb6Q9HuBgnVKu37zPHCYNw6PKfpAmVP4trKhCICqVexk61OjymcM
         ajE+rrWyYiEaYRePBmCieqMzw5ekh1Vxny2gQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fInY95no8O0JEStBsdbpcymzt287B66Fcqaxhkug+c=;
        b=zQXt2LaA/g5Ora3KAQmmyo0qvkv/P6CgWOnV3zOkHab2fZcud/iSi4uR1MeQgbBCfn
         rFM2put8fZfOjhsMi9sD9y3vuLRvwEXAUPywDhwPYWA89/eADFZ/VbUKWq7N5m/zb2Xy
         4kSqppiaq5Sd/+8Ij8w1+EMiAXmh9Mtmln0u61SXLol4KpQJpi/J+DEJdcT9UP1OYWZj
         C89HiLt8vKdKdUypl39+TFzxzBXoZAbOGc22HntkevSAQP4qyxCeaPxJpncL1TkkfAWo
         goSCjeLqp9obnIJhZKsuXT24AELYZrA3vyDKO+TaLJLkAAHAhx52z+t7DEfr4y9Zn5he
         IKYA==
X-Gm-Message-State: AOAM532BFAPNLiGUa+iChkc4veP6DQfqcQzKuo0clqc6XaoohbDf8Ept
        4VG8FXxQpdl0iYxBwmsajC8A3o/oJDDgV4Gh
X-Google-Smtp-Source: ABdhPJwBUH0++L4GXUIEc5zdbzEzRg13pZd5IfLcrfc/ArdJdiz7/FgRqmsQpxJrLs0+5i2P7POnyQ==
X-Received: by 2002:a2e:5c08:: with SMTP id q8mr429957ljb.304.1632841191519;
        Tue, 28 Sep 2021 07:59:51 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id z10sm2546354ljc.117.2021.09.28.07.59.51
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Sep 2021 07:59:51 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id z24so94887025lfu.13
        for <linux-fscrypt@vger.kernel.org>; Tue, 28 Sep 2021 07:59:51 -0700 (PDT)
X-Received: by 2002:a2e:3309:: with SMTP id d9mr387530ljc.249.1632841188299;
 Tue, 28 Sep 2021 07:59:48 -0700 (PDT)
MIME-Version: 1.0
References: <YVK0jzJ/lt97xowQ@sol.localdomain>
In-Reply-To: <YVK0jzJ/lt97xowQ@sol.localdomain>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 28 Sep 2021 07:59:32 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibMN-Bixbu8zttUoV1ixoVRNk+jyAPEmsVdBe1GFoB5Q@mail.gmail.com>
Message-ID: <CAHk-=wibMN-Bixbu8zttUoV1ixoVRNk+jyAPEmsVdBe1GFoB5Q@mail.gmail.com>
Subject: Re: [GIT PULL] fsverity fix for 5.15-rc4
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Boris Burkov <boris@bur.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 27, 2021 at 11:22 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix an integer overflow when computing the Merkle tree layout of
> extremely large files, exposed by btrfs adding support for fs-verity.

I wonder if 'i_size' should be u64. I'm not convinced people think
about 'loff_t' being signed - but while that's required for negative
lseek() offsets, I'm not sure it makes tons of sense for an inode
size.

Same goes for f_pos, for that matter.

But who knows what games people have played with magic numbers (ie
"-1") internally, or where they _want_ signed compares. So it's
certainly not some obvious trivial fix.

Pulled.

            Linus
