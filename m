Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8073EA5D8
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Oct 2019 22:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfJ3V7R (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Oct 2019 17:59:17 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44683 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727127AbfJ3V7R (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Oct 2019 17:59:17 -0400
Received: by mail-io1-f66.google.com with SMTP id w12so4321889iol.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Oct 2019 14:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7mK3Uoiwaws9OYl+5bVE084OvHB6LGX6Sfc0eSAjwc=;
        b=aKsZ4bdZUSBifwnA9EI/sfdmKnP62vGSwIqzhbMUiTCUkHM2p7iqF53Jzgdv5kXvv6
         GBFkJoqdRYLQIybUp5uZd8C9F7L2xM/7BvH0VitcMonLl80SQX9+/8cxz1Pb55faR4eW
         W84909D8+2Y2GxJriYNmqjYg9MaPiledZHFQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7mK3Uoiwaws9OYl+5bVE084OvHB6LGX6Sfc0eSAjwc=;
        b=pT5P3BBib6bfnjSB0kn2kuqIsZywAbAqrC7yxG0WxCZXkXjARwgUQKmUdvrJ6sTPgU
         Gl5ra8W01zaPNTf2redhgg7jYwptjFCNWzomoxFjUkiz77KIAd5+p89ueqYvyHDctU+k
         uuFT/ytbciaJtpsDlPt+gomMKL0YpzVovHE3vk9i+NM/mAqvkjWQctMLqHSbyaNIjv12
         kj8wl+ctbIUWR920E3GII035jlrkyolBlOzJi7z54h9gBBlSNpx2KcsE4BE/ELjX1tjz
         G4MBZmjHcmuSbyLc4ISLUe324oE4W/BBig2kM9mXK5tMGaYTW26MSs34UlVQ7c1Enzxq
         tueg==
X-Gm-Message-State: APjAAAU4GBO/RQjDlQANC+WQfEDE54JWuryX1M94oQLGNkvYJ3ypXGJ+
        RPhBgrQTKiJWu0f4Fsnl5vSCKxSo7+k=
X-Google-Smtp-Source: APXvYqwN6TK2nHJ4Y3rH6L6cRqM4V1rcZpuKLXdHJT2QReJyd8+DtfXKocrXrbN3q30qs+klJ5125A==
X-Received: by 2002:a6b:7006:: with SMTP id l6mr1817863ioc.298.1572472756393;
        Wed, 30 Oct 2019 14:59:16 -0700 (PDT)
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com. [209.85.166.170])
        by smtp.gmail.com with ESMTPSA id r1sm109179iod.69.2019.10.30.14.59.15
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 14:59:15 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id y5so3557517ilb.5
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Oct 2019 14:59:15 -0700 (PDT)
X-Received: by 2002:a92:ba1b:: with SMTP id o27mr2484026ili.269.1572472754921;
 Wed, 30 Oct 2019 14:59:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191030100618.1.Ibf7a996e4a58e84f11eec910938cfc3f9159c5de@changeid>
 <20191030173758.GC693@sol.localdomain> <CAD=FV=Uzma+eSGG1S1Aq6s3QdMNh4J-c=g-5uhB=0XBtkAawcA@mail.gmail.com>
 <20191030190226.GD693@sol.localdomain> <20191030205745.GA216218@sol.localdomain>
In-Reply-To: <20191030205745.GA216218@sol.localdomain>
From:   Doug Anderson <dianders@chromium.org>
Date:   Wed, 30 Oct 2019 14:59:03 -0700
X-Gmail-Original-Message-ID: <CAD=FV=X6Q3QZaND-tfYr9mf-KYMeKFmJDca3ee-i9roWj+GHsQ@mail.gmail.com>
Message-ID: <CAD=FV=X6Q3QZaND-tfYr9mf-KYMeKFmJDca3ee-i9roWj+GHsQ@mail.gmail.com>
Subject: Re: [PATCH] Revert "ext4 crypto: fix to check feature status before
 get policy"
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gwendal Grignou <gwendal@chromium.org>, Chao Yu <chao@kernel.org>,
        Ryo Hashimoto <hashimoto@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Guenter Roeck <groeck@chromium.org>, apronin@chromium.org,
        linux-doc@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jonathan Corbet <corbet@lwn.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

On Wed, Oct 30, 2019 at 1:57 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> FWIW, from reading the Chrome OS code, I think the code you linked to isn't
> where the breakage actually is.  I think it's actually at
> https://chromium.googlesource.com/chromiumos/platform2/+/refs/heads/master/chromeos-common-script/share/chromeos-common.sh#375
> ... where an init script is using the error message printed by 'e4crypt
> get_policy' to decide whether to add -O encrypt to the filesystem or not.
>
> It really should check instead:
>
>         [ -e /sys/fs/ext4/features/encryption ]

OK, I filed <https://crbug.com/1019939> and CCed all the people listed
in the cryptohome "OWNERS" file.  Hopefully one of them can pick this
up as a general cleanup.  Thanks!

-Doug
