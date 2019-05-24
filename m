Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A13C299E2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 May 2019 16:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403895AbfEXOPz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 10:15:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:38191 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403934AbfEXOPz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 10:15:55 -0400
Received: by mail-io1-f67.google.com with SMTP id x24so7870354ion.5;
        Fri, 24 May 2019 07:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vdyE1IbAdrPQM5ovOiRyFmLzasbQZYXuZYfheCMJqbw=;
        b=KJwYtNp1/BjIMkX4VKbEUgHdFouFvetXHPDJveI0b3Ib6xzsuqTxF7PIjCxLpW7Eap
         WJSX4UCRckSN6zNL9IiwbPkAxAj2w61Cr43tKha13ZNT0+RlQ0FwaQ9+BZABAibmQfi8
         Dw9uEq4qglSsKbNnuhTEqJsLqSkk7cH4r1Keb9LBHTQMb8d/AfpW/HqPukaEuCVscPqJ
         ro9FPkBbsEubuT6G+y2WWlnvvupvpzXnrxmfnJQ4e+HzywUy2V45iy48CI/2DeT2KY+8
         3avOHiHazJ4D37WP/HvjykI8fp+vdUi1pUI80k87kUdA7PN9fIcWPPKUYN/oyP+ZpUtW
         p3iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vdyE1IbAdrPQM5ovOiRyFmLzasbQZYXuZYfheCMJqbw=;
        b=Yit8i1kaPeY7ww2y/l0fnoo2KI6QxAq3NJmXM12CnoMrnD7d6CcvwqgBxgovaOSJPC
         uGErl70tcDZaoLZv60KthVqnfwZ5GoJC4w7FtJvEcM0WpRrU4vYqVD4yHos4R+1Z9FMz
         sID/rW9UWFG7z5XI11rG1TDUhWGIWQ7SNQDZ/FnHebmHRra6emLTMbSi9EFWTPsQi3gK
         BLcjzNq2e3NZJJOUpupTj38NAhLVsQEi7XEEqQxRqGIzzOxKUggTSl/BRzInPgCNJd3L
         cNQTBakqB8zoetXmYHuezCNbdl7RRe25uX09/66HfFqoi2NZDTgtYP4piXSUO6RvOwCH
         batw==
X-Gm-Message-State: APjAAAUyLbmP6khe+a8jaKrCEdec4pTOf9O3JYQJ4bTe53xw9zN5++z5
        HMwD3q1Jo94OCYPowA8FTEy0goGUcCwf3lX++aE=
X-Google-Smtp-Source: APXvYqzpEWaLmKIMamOmdtVUD7pEBYTszZG6g/0fHHGhV7wMzP5pF53sXIxPRicBhiro3YKd2HguOWMfSzMieT9khdc=
X-Received: by 2002:a5d:870e:: with SMTP id u14mr5195204iom.44.1558707355030;
 Fri, 24 May 2019 07:15:55 -0700 (PDT)
MIME-Version: 1.0
References: <1558685161-860-1-git-send-email-stummala@codeaurora.org>
In-Reply-To: <1558685161-860-1-git-send-email-stummala@codeaurora.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 24 May 2019 22:15:18 +0800
Message-ID: <CALOAHbCGhRymJhKLbSXzwHszUtBexE9iD=MuywEEdROvXCrh+Q@mail.gmail.com>
Subject: Re: [PATCH] mm/vmscan.c: drop all inode/dentry cache from LRU
To:     Sahitya Tummala <stummala@codeaurora.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Linux MM <linux-mm@kvack.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 24, 2019 at 4:06 PM Sahitya Tummala <stummala@codeaurora.org> wrote:
>
> This is important for the scenario where FBE (file based encryption)
> is enabled. With FBE, the encryption context needed to en/decrypt a file
> will be stored in inode and any inode that is left in the cache after
> drop_caches is done will be a problem. For ex, in Android, drop_caches
> will be used when switching work profiles.
>
> Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d96c547..b48926f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -730,7 +730,7 @@ void drop_slab_node(int nid)
>                 do {
>                         freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
>                 } while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
> -       } while (freed > 10);
> +       } while (freed != 0);
>  }

Perhaps that is not enough, because the shrink may stop when scan
count is less than SHRINK_BATCH.
Pls. see do_shrink_slab.

What about set shrinker->batch to 1 in this case ?

Thanks
Yafang
