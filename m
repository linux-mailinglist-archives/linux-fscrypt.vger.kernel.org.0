Return-Path: <linux-fscrypt+bounces-491-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4691899ABD9
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Oct 2024 20:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4940B1C2344F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Oct 2024 18:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C39B1D1509;
	Fri, 11 Oct 2024 18:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="blS+uvA/"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFB21D049F
	for <linux-fscrypt@vger.kernel.org>; Fri, 11 Oct 2024 18:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728672887; cv=none; b=f7zT0omo/Oy/i41ut5WLQEIKLIMtyFbjpVExqGATYkJRvCszlzZtR1REOrwgGswb4frSeWajlAeQ33sNlA85QjOs7wXKRPAjVGC6XFgFX/s0Rjpdr2xIebbMpYzhIiajdgLRpSm+I//l/W5zmGcs0lVdR9cwRbCXHh5LaPC+FRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728672887; c=relaxed/simple;
	bh=Wza/iRdX5cN5BMLvK7O/031QpQHLKfgshw5BLS3vTXg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EohkrpgluYgwMFWAzpNW4xOV/AIKBkGg1sk6WMdP2g8iueB1HqSasLr4MqRt3GN4GGmPKZfQmmOaozRnbzFZU/PUxbhHl6IemwsrVe4QabN7dfTOVIowWPnQd2n0fLgs/a7KdvSnKa9WeitosdLxj3VjCgiNu3fj8K1BUfDlx8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=blS+uvA/; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-37d5038c653so1166752f8f.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 11 Oct 2024 11:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1728672880; x=1729277680; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=my2XmLLe0oLXzshDoZwtb3c1+4lIWQN1dJeP5uAMxsA=;
        b=blS+uvA/o+/xPY7D7iWYDrtLb4MNqX7PHRvOUyx3fRvt23jAr0Wy8HjqawsSj+aZxR
         gv0CU7OvPrDCCrwLzUKTHLoGHyIG8I83n3WEZk09rWmwMdfeV60SD5LpNXhIwhuIBVe+
         QJYlMAbTzosfMoUwCThdA8t0MpJPkZdfqJKaog5K/BExaPxuKmhlsZV5VbqAQpa0AhiB
         rghf98e79+SE9cfp9Oqdava6TcUzZxEVyOmGr9aklCMMmkWn5Do8OvfXNtiVk1ok9Yca
         gnw6cSM4ugulb2GiNBtc863G5WwpMseJ5xVtUjyDJRozRGZ47JaHekB1/+p+XABSk4LM
         dBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728672880; x=1729277680;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=my2XmLLe0oLXzshDoZwtb3c1+4lIWQN1dJeP5uAMxsA=;
        b=Hm5wQpfuBwswsfKCYz/R5igsiVe8gfxcrCxUPJ25OcR5jJSgi3794LanJFX+lkMbZk
         GtzPtZSYwuIbxl8fmaO9qA+TY6TsqntCqsswd8oZMFPsbCdTUX5AhtW31mrmKYtj/orn
         /qw8dqbhAluVj4q9ZbfPzodMH7IxDwMRHvLnkqgNFFVjGWKRuhCt/gxQgTB8vxojoLea
         qDXRXrzqAgH1hJqYeiEDjcaQKs7LtozfereB5RS8qvZc1vaI0q3JXKGpgP370scX6XRa
         afTmTWqjYCdRZJxNTSa4JdM9xBhQVByvppZjLW77VSrmYlBcViFHSQ+uG3ETj9sbOk++
         G8KA==
X-Forwarded-Encrypted: i=1; AJvYcCW5zvaR5LxmZa9iyHdUt/Iy7aoc3gjTtDO6D7jqmlXgw+DLdkNrndtO1Pn1gZaJDpoiBt0VasUGj9X6xSuQ@vger.kernel.org
X-Gm-Message-State: AOJu0YxEEmw1G8F19FetL27YWT5GuXs0tQxz89ZgidSqh8RyEf1fpSBO
	V1VGbSOcjP8o0gBc1AxPNO/L6vpMMcK3YlXJWL5wqgG0bOa5qeQVJzxEd7fBWD0=
X-Google-Smtp-Source: AGHT+IGbn3dzWq62qhjEiOBha1cczQY5CApcqt9d8LPapIwRdeLC8r4MCRAqlB5oVEKWtD3LqRgX4g==
X-Received: by 2002:a5d:6687:0:b0:374:b3a3:3f83 with SMTP id ffacd0b85a97d-37d552cb66cmr3261399f8f.53.1728672879751;
        Fri, 11 Oct 2024 11:54:39 -0700 (PDT)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:68b8:bef:b7eb:538f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b79fe7csm4559161f8f.70.2024.10.11.11.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 11:54:39 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 11 Oct 2024 20:54:07 +0200
Subject: [PATCH v7 08/17] firmware: qcom: scm: add a call for checking
 wrapped key support
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241011-wrapped-keys-v7-8-e3f7a752059b@linaro.org>
References: <20241011-wrapped-keys-v7-0-e3f7a752059b@linaro.org>
In-Reply-To: <20241011-wrapped-keys-v7-0-e3f7a752059b@linaro.org>
To: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Asutosh Das <quic_asutoshd@quicinc.com>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Ulf Hansson <ulf.hansson@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, 
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, 
 Gaurav Kashyap <quic_gaurkash@quicinc.com>, 
 Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dm-devel@lists.linux.dev, 
 linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1813;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=IKhAxIosGYUyrB4jLR8PpwNLJS99HlSOS/sX8Ks7vvc=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBnCXReUZwO3XEhsZr47jY8a7DDI3iXaG3Rq7CgP
 QgcHMzguU2JAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCZwl0XgAKCRARpy6gFHHX
 cg0DD/9dQRMs1HXKw5jYs78wz/2NsZwB2GzXCvcG0TnicxRB+ccJx5OKc/vw1zFxt0LmyVZO/QR
 YZgMIBGtaqmSkGBcNAG6rdTBJxq7HHFvIfp12iVceX//x8JZQJW2/T7DhK3zHIWUPNSvEswpE7D
 FMiWmQnSo5vnOVHgiyPFxuN5a6AqSsbFxvj3GVUD0eAFkXLtIRD8W3GNNnVk3X46xCVvylU5OvP
 tPo9BAQ1TqhSLUfLk2Mp2QOjsvjNlKFV4p07QlvU4orJ+7DlW1KlhmYXBrdjTymFRjRPGmnMat+
 JMMqhxxmH4X2M5/DtQJ7iE/fXKpnpyGeBV0Yiu6mTvlhTk1Naf2E2l4LdJaHzmqBvwjcR8Z1X+O
 KdYZ8NHUHgi0u/4S1/uqAZ5HIZEqscnw+bTKk0BzAxI51oGCZi1K89QAuzK37MTZWiKIRjSynQ+
 X0LSGITk00Nb89EdQbKZT7bTe/oWU4FiT2wRaLbM91iY5xkchJNBJLbEArAdMK0knpYUtbKjngw
 Z9syaFpoz8BXpVfvXoXXacnNv74N9uthQ4aQhRm+2XkTojpNuSxdTu5OlS/Uzz17l3YAmJ30rpa
 wBrqtlTUp191o3unS+q1hgFesrQhxGLNPz+foTZz7P2XrCpiQn5UOwwSLJe2YvbFe1wqWuxQIWP
 JLXlY21s0tzpeqw==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Add a helper that allows users to check if wrapped key support is
available on the platform by checking if the SCM call allowing to
derive the software secret from a wrapped key is enabled.

Reviewed-by: Konrad Dybcio <konradybcio@kernel.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/firmware/qcom/qcom_scm.c       | 7 +++++++
 include/linux/firmware/qcom/qcom_scm.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 3a59fd2a45b5..f1f723b53e8f 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -1252,6 +1252,13 @@ int qcom_scm_ice_set_key(u32 index, const u8 *key, u32 key_size,
 }
 EXPORT_SYMBOL_GPL(qcom_scm_ice_set_key);
 
+bool qcom_scm_has_wrapped_key_support(void)
+{
+	return __qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_ES,
+					    QCOM_SCM_ES_DERIVE_SW_SECRET);
+}
+EXPORT_SYMBOL_GPL(qcom_scm_has_wrapped_key_support);
+
 /**
  * qcom_scm_derive_sw_secret() - Derive software secret from wrapped key
  * @wkey: the hardware wrapped key inaccessible to software
diff --git a/include/linux/firmware/qcom/qcom_scm.h b/include/linux/firmware/qcom/qcom_scm.h
index b5ab39b35490..94d4e3c96210 100644
--- a/include/linux/firmware/qcom/qcom_scm.h
+++ b/include/linux/firmware/qcom/qcom_scm.h
@@ -110,6 +110,7 @@ int qcom_scm_prepare_ice_key(const u8 *lt_key, size_t lt_key_size,
 			     u8 *eph_key, size_t eph_size);
 int qcom_scm_import_ice_key(const u8 *imp_key, size_t imp_size,
 			    u8 *lt_key, size_t lt_key_size);
+bool qcom_scm_has_wrapped_key_support(void);
 
 bool qcom_scm_hdcp_available(void);
 int qcom_scm_hdcp_req(struct qcom_scm_hdcp_req *req, u32 req_cnt, u32 *resp);

-- 
2.43.0


