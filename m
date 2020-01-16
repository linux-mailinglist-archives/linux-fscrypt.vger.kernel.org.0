Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1213F98E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Jan 2020 20:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730202AbgAPTca (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jan 2020 14:32:30 -0500
Received: from mail-pj1-f42.google.com ([209.85.216.42]:53458 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729010AbgAPTca (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jan 2020 14:32:30 -0500
Received: by mail-pj1-f42.google.com with SMTP id n96so2016898pjc.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jan 2020 11:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=hyzNv1dc1GVO6cS6VROlN8Ir53SYiOqZS4xcJGfOV6c=;
        b=ZUOPzjcwEB6K0xs02EzuaFt1lBdlZYxhuJ7kIYJGQ7jhxIkxkS7AGSG8EUk2o0gCyl
         fp9Tcdmts/GW/FSR3DReSNOdRwGm/sUOSd2oLe9pCRbGpZcktnAhm9uLffVLUrH4fZkF
         7FuZiezzSxfXfMOa5wJBGSeTfGKkYqvHtQHJYZNFfddy3hlPjvq9qyIAWPbYrgWOs4TO
         NTEjoNs6cFOn8UAb7OiVJ3OHZ9tbGcpw+g1Huccdb2mZoaDuGpsUrtVamUDjgfgc55MY
         qwuCR+PXmUI3VYU8iIv2BTusJCORKYVp8zF2JNC/fnLbuZ+58F8fK1OlTwpkxgL8Q0lZ
         PkJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=hyzNv1dc1GVO6cS6VROlN8Ir53SYiOqZS4xcJGfOV6c=;
        b=tCJALuwkJJ/ZlSFlvXMjNzP2tmVcfnGPE69jKiAzxomljjRcZb8mJGgI4+VEug1who
         JaL8MM7JdgRjahazcn4dD8HXGC7nW6FqDkYEq7V9h6JuMD2jG9voPrdmA+zVir6yTPwx
         nRfjc9KgNUykZs/vxZeQWUuivgEJCL3vmWam8CcAMYInzTQ3O5oBLCjNbtYLIgi530sq
         CHlnjyyVf67lmc7WweRT/zMFzaiAOtCnUUzlVZ23Qp7jj3Lp6begJ/4NXPZyLddiScdj
         Z5cN+b9Kf5pOHtGkv6npDvrARplZA2n1rp36LdsmeZHaNd6IkL3jLiBfOKx/6Q0LxmmP
         12mQ==
X-Gm-Message-State: APjAAAUyWoMm4kfnFiZLGC73OZzu8CQUC7CdTBugZ+LH/Nju3tO0Ei3w
        Yj8zSxHo/VvP2JO6YF4loQVAdcD72Io=
X-Google-Smtp-Source: APXvYqwybF5t1DT4eV6oIGWaXK7Qgp4n0PtIcWlUZJLmfsgSJWnlGd1Nq1MPFT3cKJg4ingWCL6Wyw==
X-Received: by 2002:a17:902:8ec2:: with SMTP id x2mr39932368plo.102.1579203149251;
        Thu, 16 Jan 2020 11:32:29 -0800 (PST)
Received: from vader ([2620:10d:c090:180::593e])
        by smtp.gmail.com with ESMTPSA id 80sm26876111pfw.123.2020.01.16.11.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 11:32:28 -0800 (PST)
Date:   Thu, 16 Jan 2020 11:32:28 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     Sergey Anpilov <anpilov@fb.com>, Pavlo Kushnir <pavlo@fb.com>
Subject: Using TPM trusted keys (w/ v2 policies?)
Message-ID: <20200116193228.GA266386@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

We're exploring fscrypt, and we were hoping to make use of a trusted key [1] so
that we could avoid exposing the master key to userspace. I found a patch [2]
from a couple of years ago adding this support. However, trusted keys in the
kernel seem to be tied to the keyring, which is not used for v2 encryption
policies. Seeing as v1 policies are considered deprecated, what would be the
way to move forward with this feature? Would it make sense to add minimal
keyring integration for v2 policies in order to support this use case?

Thanks!

1: https://www.kernel.org/doc/html/latest/security/keys/trusted-encrypted.html
2: https://lore.kernel.org/linux-fscrypt/20180118131359.8365-1-git@andred.net/
