Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6887D2EF562
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Jan 2021 17:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbhAHQCU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 8 Jan 2021 11:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbhAHQCR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 8 Jan 2021 11:02:17 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AB6C0612A4
        for <linux-fscrypt@vger.kernel.org>; Fri,  8 Jan 2021 08:00:56 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id w79so8816676qkb.5
        for <linux-fscrypt@vger.kernel.org>; Fri, 08 Jan 2021 08:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ik6B+6lkNc+iFrIPLOlH6nyfA0JsJ4cRGzVhof+Ll8w=;
        b=VpA/rpQ5qi0dFR7Mowe5aGCpF9u7a1VmQn5q9ZZuQCrdDN5tZn6sXwU9XTDBXmdfYo
         GHrqoepeF5HsPEyz7s83Q2FgcvfAPgYumhvcRGiBVC2GK+C5XV14Ui++lS3so5pA2/iT
         1rfJS9pZ3rxyDmU9J33KM0ODd0VovMdrCXj4PDHLrX+mNc/gXoaOQ9JB4dQ8+Pi+t3Y5
         owDd0dhEIxx5inTgS9uv9USD9ua3iUgbE7ZeBpPZmm3e8Mr6fY26xd3tbIKjFdXg+Z5e
         HzKpZOj3j3xkWAI+2U0PJ6WCaJvaJp4eQ7JPK2DyyOLy9Is9PPJi0kyYoCvOmtdELPp9
         eESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to:content-transfer-encoding;
        bh=ik6B+6lkNc+iFrIPLOlH6nyfA0JsJ4cRGzVhof+Ll8w=;
        b=CI2Z0JxPuvU7h0+xYgZRdz9Wm3QjCogPdo9+Sq0kVYFkr7HgAKXxaBkOyYSbdmno1A
         nFQdI/MHzKT+JBcNGo1eVNoiQVv+ZETxU8rEOBZlAZ7vlAK5rMVCAiQthqYrNCy3ospz
         PbUJWsUMm7WfR47uuRrwA+h7D49TyXwPseAvGwTCwb1KY+UdpXVk437BgQN2mVXL3L6L
         Rsm69OkZhkT4Lv/D5jK8PbvaRcgyQQy8HyzRZUaoaM5QgP7SppVsRwwLEw6RupGzPl7d
         vhpMhoPGoubjI1cv+adWGeUVzV/XpABon29FAtVMXyXT/Xk3CCuH7D8KNBkgA+ZittWW
         3L0g==
X-Gm-Message-State: AOAM533/SZxygThEVQCj6z62DHtJFYS4rVWOsel8aFOYqtlssOoBf4XW
        egYxTmWFIXxVq0/gWqbY3Jkkp5vl4yxPk5GWx64=
X-Google-Smtp-Source: ABdhPJy5DcDb2tpoN6hwwNxbrQ4+6iS7cEF5BYexkcUy5+hBuogz8U9cM9vP/oN0NUHGYqGpdQYDJc3bSIrriX19zaw=
X-Received: by 2002:a37:9f14:: with SMTP id i20mr4583418qke.321.1610121655742;
 Fri, 08 Jan 2021 08:00:55 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6214:148d:0:0:0:0 with HTTP; Fri, 8 Jan 2021 08:00:55
 -0800 (PST)
Reply-To: camillejackson021@gmail.com
In-Reply-To: <CAGCmbMQupVT-1ZX2--N7Bjf2eW4VuUQ4dE_hzd1qAGQuE_JBEQ@mail.gmail.com>
References: <CAGCmbMQupVT-1ZX2--N7Bjf2eW4VuUQ4dE_hzd1qAGQuE_JBEQ@mail.gmail.com>
From:   camille jackson <adamraouf78@gmail.com>
Date:   Fri, 8 Jan 2021 16:00:55 +0000
Message-ID: <CAGCmbMR9p4PyoggcTsQ1z8w+PCmEh+pd463ifnbWZyKw1o3FtQ@mail.gmail.com>
Subject: =?UTF-8?B?0JfQtNGA0LDQstGB0YLQstGD0LnRgtC1LA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

0J/RgNC40LLQtdGC0YHRgtCy0YPRjiDRgtC10LHRjywg0LzQvtC5INC00YDRg9CzLCDQvdCw0LTQ
tdGO0YHRjCwg0YLRiyDQsiDQv9C+0YDRj9C00LrQtSwg0L/QvtC20LDQu9GD0LnRgdGC0LAsINC+
0YLQstC10YLRjCDQvNC90LUNCtCx0LvQsNCz0L7QtNCw0YDRjywNCg==
