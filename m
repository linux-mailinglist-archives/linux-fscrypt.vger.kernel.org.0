Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA72B28CC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 23:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgKMWyY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 17:54:24 -0500
Received: from mout.gmx.net ([212.227.17.20]:42241 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKMWyY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 17:54:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605308062;
        bh=GS+hQG/eVfKYhZN1QWK3waff4+wcT82GmC29HxPzEIw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=Gr63NeW1snv0HHYUMT+0WHek1yqFq5uIcp3xRIJp77l+t6bpAFYa7L+52R/kG/Nwh
         0knVlClrqehF0ghV1qKnHnktmlPF95Sh7JT/qjlavKToIjGQhlEs8pxdVtVHjVUb7p
         5meO5HWXXQxQW9vnyssJiRFq08ns4+O7C6CrCbeM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([91.61.48.149]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MLQxX-1kuY9d2v1n-00IX2c; Fri, 13
 Nov 2020 23:54:22 +0100
Date:   Fri, 13 Nov 2020 23:54:21 +0100
From:   Marcus =?utf-8?B?SMO8d2U=?= <suse-tux@gmx.de>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils RFC PATCH] Add libfsverity_enable() API
Message-ID: <20201113225421.552sw2aguupcrvkp@linux>
References: <20201113143527.1097499-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113143527.1097499-1-luca.boccassi@gmail.com>
X-Provags-ID: V03:K1:LsONwIWKGwwT1iU/hc8gEwo5unfLWXJTWhPzZzUUorfOuge5gzv
 K5Etq00ftiIBseEAod2hcxPbKe8Z6djUONGpHG0TfRZJ5CCDq6RfYhLtmxaJIEkoTjT8cU2
 u+jw/PYM5Q6eZywDhs76ccKbKXbtY+dds6cfogBRXE9gXb7v5gVS4pKktWv2z1kQOwNvXzZ
 TtKzP9y6SYF+INoslaMoA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oUAKpsozkLw=:h556xuyJ5PTLuV0c83O3J+
 HS3QoaohY9KZy/kh+MR1H86AKXHiveb70fpkhqt0M8nPe1AqzKBiMCFE5VFEanK3DlgdEP9ud
 g7WY5JcQ0cD0qUpG/gD1390VlVd1zuwsx1bRmOBaOP7O1MiCdYGECVALuUM31mdCqn1Zm5UKy
 u4dwK7hANJ7B+A5YXgilCDqQSkH8YPQrf/WiCAUhobF4DnPe/maxRryFtLf5z62BmOLpzZyK9
 iKPor6s8OAQgOliqzgNeLWJNWYa5c9rY2IRADuAJr0NoLIhHWhjJiuf96qCP13Q5bQMeOS22n
 Bk1KK/BYAlckgpZHXqKiueb9taoV3wR/CEitNonDRhy6VXXztgO2UByWHNRY2zvLneqbDxRb+
 LwY7rTbY8U96Fov47oj7EKE86XjArml8fJWjEfNfCzRbFue+nsgtCJ+irBfgCciX07ccqZznn
 AC2R6ZAUiaqHvCfsPrEaZxhjfnh81HhcbzvC93xgArB5kzv9wSRnhg3ftdocFv7td3fh2CfoD
 ZqV2XNrf8+Y2NDru71VmJ2RQeTVT7m7C0nbYoe4R6cAg/ZX5DVC7XSkbpEuuqb0zqFozrW7Z6
 ywb/HpKKUBd6pN2E0kX6Ex/RbL/T/zatEpR+ZUqNEbT6VUK1rpEE2hw4PEFDePsgBtv6FNKDu
 dGxhZcA7D/Ni3mWCsB92K0SK6iYWsDVtNdiAc6U4WdgUpiExkXkQF+aX2Ui/jactFmXSyy0qG
 bTjTJ6pM/YNRntMC92/jQonymeHP03Le7MFI0TAkqhoBYJX5MH0Fzt9LAnvBGIZHa+wFbiDir
 1gzT/t2S9PE3y1hp3HCd4k3EmfRkiq2TFBwYD4oL5nhY0BXX/XoLDp/4w7BmeFQrAqVTiuP32
 OMTKeXfX5Gxaqs54vPeA==
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020-11-13 14:35:27 +0000, luca.boccassi@gmail.com wrote:
> diff --git a/lib/enable.c b/lib/enable.c
> new file mode 100644
> index 0000000..ad86cc5
> --- /dev/null
> +++ b/lib/enable.c

...

> +static bool open_file(struct filedes *file, const char *filename, int flags, int mode)
> +{
> +	file->fd = open(filename, flags, mode);
> +	if (file->fd < 0) {
> +		libfsverity_error_msg("can't open '%s' for %s", filename,
> +				(flags & O_ACCMODE) == O_RDONLY ? "reading" :
> +				(flags & O_ACCMODE) == O_WRONLY ? "writing" :
> +				"reading and writing");
> +		return false;
> +	}
> +	file->name = strdup(filename);

Hmm we should probably check for NULL.

> +	return true;
> +}

(Otherwise, I cannot really comment on the patch...)


Marcus
