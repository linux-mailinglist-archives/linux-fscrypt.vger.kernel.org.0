Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF41D2332E1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Jul 2020 15:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgG3NVx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 30 Jul 2020 09:21:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50961 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3NVx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 30 Jul 2020 09:21:53 -0400
Received: from mail-lj1-f200.google.com ([209.85.208.200])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1k18VL-00038f-2v
        for linux-fscrypt@vger.kernel.org; Thu, 30 Jul 2020 13:21:51 +0000
Received: by mail-lj1-f200.google.com with SMTP id t17so968297ljg.16
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Jul 2020 06:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=ODSz9MB7YpkZeQa0ECYKsJ9CyYRThtTlzTFjZDaZ4Ec=;
        b=LGE7UORF6+FP6zqY6Hu0ffNHFOMiyglAQlOE69eYhA/NRCbzFrDS43snh23PZ546DD
         TqBnduJDxqN+K7quTES+5IRltp11fj3qBEGzqkBRuLoATjy46f2aDOu19EpejpxXpBP1
         DN20R9/wG6nvEhlFEeMOIft+nqRyrJuiBoUwqFAsuQh+VU/y3urfc6K6kvq9qZCvJDsz
         TTNc70ifchRngOhLFOEj4GQB7paTuy/jM6M73hJ6H5stMF2enCsp8JXHCdigRp8YqKM2
         e4YlovJyzrYzvU5wpdJIUT2RQQCXCG4sMhpoFecwj5tXkV0iVwaB+EmclGmTMTVfB8tg
         D3Qg==
X-Gm-Message-State: AOAM53079ex2MSd33YnEmss5DAj/BGkDY58CK8xG6Qnl+w4AuE2cHtO6
        CmlLskSXMkl4Zq/tt8pPhOg/mR1JJYyF+FsybNIfq900lbVOX+BD7rEEJSY1jTUt+82nsaZEN+T
        gErCqR2TzmjdnuBTXANhHcTdqX6JwSd80OGGVbmc+KDrSEv8TnalRYmiI3w==
X-Received: by 2002:a2e:581c:: with SMTP id m28mr439152ljb.5.1596115310397;
        Thu, 30 Jul 2020 06:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4ae4v3t2wzWbG8TI9suno0TRW0U8orEWWcjo8cc7jw3Vx0p5Cu62q+9z16sSnx9fqApyTEthq2BHzlUjhx/E=
X-Received: by 2002:a2e:581c:: with SMTP id m28mr439144ljb.5.1596115310127;
 Thu, 30 Jul 2020 06:21:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200730093520.26905-1-po-hsu.lin@canonical.com>
In-Reply-To: <20200730093520.26905-1-po-hsu.lin@canonical.com>
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
Date:   Thu, 30 Jul 2020 21:21:38 +0800
Message-ID: <CAMy_GT-JNP0aTM3wC2mniMrREGkHGHuc2G=4Wmj99AFXULa6hQ@mail.gmail.com>
Subject: Re: [PATCH] Makefile: improve the cc-option compatibility
To:     linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

BTW this is for fsverity-utils.

I should put a [fsverity-utils] in the title, sorry about this.
I can resubmit one if you need.

Thank you
PHLin

On Thu, Jul 30, 2020 at 5:35 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
>
> The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
>     cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’
>
> This unsupported flag is not skipped as expected.
>
> It is because of the /bin/sh shell on Ubuntu, DASH, which does not
> support this &> redirection. Use 2>&1 to solve this problem.
>
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 7d7247c..a4ce55a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -27,7 +27,7 @@
>  #
>  ##############################################################################
>
> -cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
> +cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
>               then echo $(1); fi)
>
>  CFLAGS ?= -O2 -Wall -Wundef                                    \
> --
> 2.25.1
>
