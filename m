Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB63183C00
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 23:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgCLWLa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 18:11:30 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46555 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgCLWLa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 18:11:30 -0400
Received: by mail-lf1-f65.google.com with SMTP id r9so700382lff.13
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 15:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+nbJgOAkU3OKGNy5HAiFcAe6BZ2/dfnnfHDkezdsLM=;
        b=lLp+JNv1GIglmiE7sOrC1qiIR92TS5cKLDQInmmSnSrfr1qRJIqEePz4qZzmCMaXQg
         WfjeGL9/4gKBTTDka+GpLlLtpbiD1yloqRAJ0j1uaN1RPyfrSudbA4agtp71u5vQLvVh
         kbfpE2jpEmTv+gLLK2bdDBoWn9tFPGdA8uR+LZOOg0cNSMA//V8Yzq7FYJEWfGS9egxp
         ssrmkKAtsOcFrY+F+ktTdm/G2ys1pRbkX5kFFOvXt+HDZmd1myZbaTJUa01dn3e+L37B
         lhEYR0ODVOxYIzPOrxSPTQoqyVKo30x+HMDzyYjtalF/Xk6Pf7WKXUgxp0pP1/UDQYLp
         ZXFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+nbJgOAkU3OKGNy5HAiFcAe6BZ2/dfnnfHDkezdsLM=;
        b=TwdT+XusFD2msBUF/x7jz/G/+n/2KSj5/4obOtVqN1TF8u+Rn0u9uKnS69ALLS4DVX
         PGilnQZCyoAvhhZAgBOCBXdX3j7yvrzCm74pEqLDDk4CeqfkCnTRRiYKGrPVNieAZDcm
         2v8Ap9Ly/kloZAsttdJrgLBSKkRMS32HUZy+FLAbmT0uxSj7waPD+z5AL4e0fVhjTvJi
         /0mTL9KoeG1c3JwMfUD7k3QPfI4741EG+2tfmrUkL1WY95tqMy/f7tBqPpuwBGEO00wx
         aqGHyV5lVM/heBUlTgbXFVsuxSuDJAqCUceHfB6EdHLUGaKpN7eSP5uG+eszIKJesRZe
         8qKA==
X-Gm-Message-State: ANhLgQ34oBc4WCFGeQqOCqcctUVKoiYASm9j5+5G9TezBmO350yGquoK
        k8AY+F8TwLIN4vxtekSbB21kNs2R7Ig+JbUgsVawew==
X-Google-Smtp-Source: ADFU+vuw+qDSh0ZHQbXiX986v1sXjlwq0l/RRl8ekqAVAeCDt4hyCXShVedgqdcfYfGOHvVzkalKAjAB5l3YONcMxRA=
X-Received: by 2002:a19:4354:: with SMTP id m20mr2516445lfj.166.1584051087657;
 Thu, 12 Mar 2020 15:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200307023611.204708-1-drosen@google.com> <20200307023611.204708-3-drosen@google.com>
 <20200307034850.GH23230@ZenIV.linux.org.uk>
In-Reply-To: <20200307034850.GH23230@ZenIV.linux.org.uk>
From:   Daniel Rosenberg <drosen@google.com>
Date:   Thu, 12 Mar 2020 15:11:16 -0700
Message-ID: <CA+PiJmR=zp9P_Mam2EuVgy-vZftDTGQWuFmuO6asPeU_jEy8OQ@mail.gmail.com>
Subject: Re: [PATCH v8 2/8] fs: Add standard casefolding support
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Mar 6, 2020 at 7:48 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Fri, Mar 06, 2020 at 06:36:05PM -0800, Daniel Rosenberg wrote:
>
>         Have you even tested that?  Could you tell me where does the calculated
> hash go?  And just what is it doing trying to check if the name we are about to
> look up in directory specified by 'dentry' might be pointing to dentry->d_iname?

Turns out I tested exactly not that :/ Ran tests on the wrong kernel.
I've fixed my setup so that shouldn't happen again. The calculated
hash there goes exactly nowhere because I failed to copy it back into
the original qstr.
I'm trying to see if the name is a small name, which, if my
understanding is correct, is the only time a name might change from
underneath you in an RCU context. This assumes that the name either
comes from the dentry, or is otherwise not subject to changes. It's
based around the check that take_dentry_name_snapshot does. It does
feel a bit sketchy to assume that, so I'm very open to other
suggestions there.

I'm going through that hassle because the various utf8 functions do a
lot of dereferencing the string and manipulating pointers by those
values, expecting them to be consistent. It might be enough to just go
through that code and add a bunch of checks to make sure we can't
accidentally walk off of either end.
